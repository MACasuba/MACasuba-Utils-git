/*
 GKSession.h
 GameKit
 
 Copyright 2009 Apple, Inc. All rights reserved.
 
 The Game Connectivity Kit (GCK) is a framework for handling connectivity and data transport in multiplayer network games.  
 
 With the GCK API, a developer can setup a game network, which consists of players connected to each other for a game.  The API supports setting up and connecting a client/server game, or a peer-to-peer game (any peer can be the game server).
*/

#import <Foundation/Foundation.h>
#import "GameKitDefines.h"

@class GKSession;
@protocol GKSessionDelegate;

/* Delivery options for GKSession's -(BOOL)sendData... methods.
*/
typedef enum {
	GKSendDataReliable,		// a.s.a.p. but requires fragmentation and reassembly for large messages, may stall if network congestion occurs
    GKSendDataUnreliable,	// best effort and immediate, but no guarantees of delivery or order; will not stall.
} GKSendDataMode;

/* Specifies how GKSession behaves when it is made available.
*/
typedef enum {
    GKSessionModeServer,    // delegate will get -didReceiveConnectionRequestFromPeer callback when a client wants to connect
    GKSessionModeClient,    // delegate will get -session:peer:didChangeState: callback with GKPeerStateAvailable, or GKPeerStateUnavailable for discovered servers
    GKSessionModePeer,      // delegate will get -didReceiveConnectionRequestFromPeer when a peer wants to connect, and -session:peer:didChangeState: callback with GKPeerStateAvailable, or GKPeerStateUnavailable for discovered servers
} GKSessionMode;

/* Specifies the type of peers to return in method -peersWithConnectionState:
*/ 
typedef enum
{
	GKPeerStateAvailable,    // not connected to session, but available for connectToPeer:withTimeout:
	GKPeerStateUnavailable,  // no longer available
	GKPeerStateConnected,    // connected to the session
	GKPeerStateDisconnected, // disconnected from the session
	GKPeerStateConnecting,   // waiting for accept, or deny response
} GKPeerConnectionState;

/* Callbacks to the GKSession delegate.
*/
@protocol GKSessionDelegate <NSObject>

@optional

/* Indicates a state change for the given peer.
*/
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state;

/* Indicates a connection request was received from another peer. 
 
Accept by calling -acceptConnectionFromPeer:
Deny by calling -denyConnectionFromPeer:
*/
- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID;

/* Indicates a connection error occurred with a peer, which includes connection request failures, or disconnects due to timeouts.
*/
- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error;

/* Indicates an error occurred with the session such as failing to make available.
*/
- (void)session:(GKSession *)session didFailWithError:(NSError *)error;

@end

/* The GKSession handles networking between peers for a game, which includes establishing and maintaining connections over a game network, and network data transport.
*/
GK_EXTERN_CLASS @interface GKSession : NSObject {
@private
	id _session;
}

/* Creating a GKSession requires a unique identifier, sessionID, and mode.  All instances of the application must have the same sessionID in order to be able to join a game network.  Additionally, the GKSession requires a name, which is used to identify the specific instances of the application.

If sessionID = nil then the GKSession will use the app bundle identifier.
If name = nil then GKSession will use the device name.
*/
- (id)initWithSessionID:(NSString *)sessionID displayName:(NSString *)name sessionMode:(GKSessionMode)mode;

@property(assign) id<GKSessionDelegate> delegate;

@property(readonly) NSString *sessionID;
@property(readonly) NSString *displayName;
@property(readonly) GKSessionMode sessionMode;
@property(readonly) NSString *peerID;			// session's peerID

/* Toggle availability on the network based on session mode and search criteria.  Delegate will get a callback -seesion:didReceiveConnectionRequestFromPeer: when a peer attempts a connection.
*/
@property(getter=isAvailable) BOOL available;

/* The timeout for disconnecting a peer if it appears that the peer has lost connection to the game network 
*/
@property(assign) NSTimeInterval disconnectTimeout; // default is 20 seconds

/* Return the application chosen name of a specific peer
*/
- (NSString *)displayNameForPeer:(NSString *)peerID;

/* Asynchronous delivery of data to one or more peers.  Returns YES if delivery started, NO if unable to start sending, and error will be set.  Delivery will be reliable or unreliable as set by mode.
*/
- (BOOL)sendData:(NSData *) data toPeers:(NSArray *)peers withDataMode:(GKSendDataMode)mode error:(NSError **)error;

/* Asynchronous delivery to all peers.  Returns YES if delivery started, NO if unable to start sending, and error will be set.  Delivery will be reliable or unreliable as set by mode.
*/
- (BOOL)sendDataToAllPeers:(NSData *) data withDataMode:(GKSendDataMode)mode error:(NSError **)error;	// errors: buffer full, data too big

/* Set the handler to receive data sent from remote peers.
*/
- (void)setDataReceiveHandler:(id)handler withContext:(void *)context;  // SEL = -receiveData:fromPeer:inSession:context:

/* Attempt connection to a remote peer.  Remote peer gets a callback to -session:didReceiveConnectionRequestFromPeer:.  

Success results in a call to delegate -session:peer:didChangeState: GKPeerStateConnected
Failure results in a call to delegate -session:connectionWithPeerFailed:withError:
*/
- (void)connectToPeer:(NSString *)peerID withTimeout:(NSTimeInterval)timeout;
- (void)cancelConnectToPeer:(NSString *)peerID;

/* Methods to accept or deny a prior connection request from -session:didReceiveConnectionRequestFromPeer:
*/
- (BOOL)acceptConnectionFromPeer:(NSString *)peerID error:(NSError **)error;	// errors: cancelled, or timeout
- (void)denyConnectionFromPeer:(NSString *)peerID;

/* Disconnect a peer from the session (the peer gets disconnected from all connected peers).
*/
- (void)disconnectPeerFromAllPeers:(NSString *)peerID;

/* Disconnect local peer
*/
- (void)disconnectFromAllPeers;

/* Returns peers according to connection state
*/ 
- (NSArray *)peersWithConnectionState:(GKPeerConnectionState)state;
@end
