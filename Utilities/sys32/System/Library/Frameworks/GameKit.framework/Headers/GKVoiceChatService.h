/*
  GKVoiceChatService.h

  Copyright 2009 Apple Inc. All rights reserved.
 
 This service is useful for setting up a voice chat in two cases.
 1) You have a server that connects two clients, but you have no way of establishing a peer-to-peer channel.
    An example of this case is if you had an xmpp (jabber) client, and wanted to add voice chat.

 2) Or, you already have a peer-to-peer application that you want to add voice chat to.  
	For instance, most networked games are peer-to-peer.  You could add voice chat to your game using this class.
 
 Implementation example for an application that has a peer-to-peer channel established already.
 
 PeerToPeerHockeyClient<VoiceChatClient, VoiceChatPeerToPeerChannel> hockeyClientA;
 
 vcService = [GKVoiceChatService defaultVoiceChatService];
 vcService.client = hockeyClientA;
 
 *** During the init, the GKVoiceChatService will check to see if the -sendRealTimeData:toParticipantID: method is implemented by the client.
     The Voice Chat Service will first attempt to negotiate its own connection, and then use the hockeyClient tunnel if it fails.
 
 *** some time later the hockeyClient with participantID A connects p2p with hockeyClient with participantID B.
 

 *** A wants to set up a voice chat with @"B"
 [vcService startVoiceChatWithParticipantID: @"B" error: nil];

 *** The vcService will then sendData using the VoiceChatClient protocol method.
 [client sendData:inviteData toParticipantID:@"B"]
 
 *** When B receives the data it passes it down to B's vcService 
 [hockeyClientB.vcService receivedData:data fromParticipantID:@"A"]
 
 *** vcService will inform its VoiceChatClient (hockeyClientB) that it recevied the invite
 [client voiceChatService:self receivedVoiceChatInvitationFromParticipantID:@"A" callID: 123]

 *** B accepts the connection and calls:
 
 [hockeyClientB.vcService acceptCallID: (NSInteger) 123 error:NULL];

 *** The GKVoiceChatService establishes a voice chat and informs the hockey client of a successful voice chat session***
 [clientA voiceChatService:self didStartWithParticipantID:@"B"];
 [clientB voiceChatService:self didStartWithParticipantID:@"A"];

 As the voice chat service generates audio it will call
 
 [clientA sendRealTimeData:audio toParticipant:@"B"];
 [clientB sendRealTimeData:audio toParticipant:@"A"];
 


 Implementation examples for an application that has uses a server to establish connections between clients and wants to add peer-to-peer voice chat.  We'll use an XMPP chat client as an example.
 
 XMPPClient<VoiceChatClient, VoiceChatPeerToPeerChannel> xmppClientA;
 
 vcService = [GKVoiceChatService defaultVoiceChatService];
 vcService.client = xmppClientA;
 
 *** During the init, the GKVoiceChatService will check to see if @selector(sendRealTimeData:toParticipant:) method is implemented by the client.
 The Voice Chat Service will know to negotiate its own Peer To Peer channel since our xmpp client does not implement this method.
 
 *** Assume the xmppClient has a jabber id of clientA@jabber.foo.org and wants to start a voice chat with clientB@jabber.foo.org ***
 
 [xmppClientA.vcService startVoiceChatWithParticipantID: @"clientB@jabber.foo.org"];
 
 *** The Voice Chat Service will then try to send necessary connection info to clientB@jabber.foo.org using the server channel that the XMPP client implements.
 
 [client voiceChatService:self sendData:(NSData *) data toParticipantID: clientB@jabber.foo.org ];
 
 *** xmppClientA will implement the sendConnectionData like this
 
 [xmppClientA wrapAndSendData:(NSData *) data toJid: clientB@jabber.foo.org]
 
 *** On the remote side the xmppClient for clientB@jabber.foo.org should 
 
 NSData *serviceData [xmppClientB unwrapData:(NSData *) data fromJid: clientB@jabber.foo.org]
 [xmppClientB.vcService receivedData: serviceData fromParticipantID:participant];
 
 *** Upon receiving this connection data.  vcServiceForXMPPClientB will do the following:
 [client voiceChatService:self receivedVoiceChatInvitationFromParticipant: clientA@jabber.foo.org callID: 1]
 
 *** Client B will then pop up a dialog.  The user will choose to accept.  So B will notifiy the voice chat service.
 [xmppClientB.vcService acceptConnection: (callid)];
 
 *** The voice chat service on both sides will attempt to establish a peer-to-peer connection.  If they are successful then both voice chat services will call
 [client voiceChatService: self didStartWithParticipantID:@"clientB(orA)@jabber.foo.org]
 
 The sending and receiving of audio is then done transparently by the GKVoiceChatService.
 
*/

#import <Foundation/Foundation.h>
#import "GameKitDefines.h"

@class GKVoiceChatService;

//All clients will need to implement this protocol
@protocol GKVoiceChatClient <NSObject>

@required

//this channel will only be used to setup voice chat, and not to send audio data. The only requirement is that messages are sent and received within a few (1-2) seconds time.
- (void)voiceChatService:(GKVoiceChatService *)voiceChatService sendData:(NSData *)data toParticipantID:(NSString *)participantID; //must be sent within some reasonble period of time and should accept at least 512 bytes.

- (NSString *)participantID; // voice chat client's participant ID

@optional

//should be sent immediately with no delay on a UDP peer-to-peer connection.  
// If this method is implemented, then the Voice Chat Service will not attempt to set up a peer-to-peer connection. And will rely on this one.  To transmit audio.
- (void)voiceChatService:(GKVoiceChatService *)voiceChatService sendRealTimeData:(NSData *)data toParticipantID:(NSString *)participantID;

- (void)voiceChatService:(GKVoiceChatService *)voiceChatService didStartWithParticipantID:(NSString *)participantID;

- (void)voiceChatService:(GKVoiceChatService *)voiceChatService didNotStartWithParticipantID:(NSString *)participantID error:(NSError *)error;

- (void)voiceChatService:(GKVoiceChatService *)voiceChatService didStopWithParticipantID:(NSString *)participantID error:(NSError *)error;

- (void)voiceChatService:(GKVoiceChatService *)voiceChatService didReceiveInvitationFromParticipantID:(NSString *)participantID callID:(NSInteger)callID;

@end


// GKVoiceChatService provides voice chat capabilities depending on your networking situation.
GK_EXTERN_CLASS @interface GKVoiceChatService : NSObject {
	@private
	id _voiceChatService;
}

+ (GKVoiceChatService *)defaultVoiceChatService;

@property(assign) id<GKVoiceChatClient> client;

// May fail if you already in a chat, or if there is no peer-to-peer channel that can be made to the participant.
- (BOOL)startVoiceChatWithParticipantID:(NSString *)participantID error:(NSError **)error;

- (void)stopVoiceChatWithParticipantID:(NSString *)participantID;

//callID is returned by didReceiveInvitationFromParticipantID call. An error may occur if there can be no viable connection made to the remote participant.
- (BOOL)acceptCallID:(NSInteger)callID error:(NSError **)error;

//callID is returned by didReceiveInvitationFromParticipantID call.
- (void)denyCallID:(NSInteger)callID;

// will only be called by the client if the client has a pre-established peer-to-peer UDP connection.  Used to receive audio.
- (void)receivedRealTimeData:(NSData *)audio fromParticipantID:(NSString *)participantID;

// will be called by the client otherwise.
- (void)receivedData:(NSData *)arbitraryData fromParticipantID:(NSString *)participantID;

@property(nonatomic, getter=isMicrophoneMuted) BOOL microphoneMuted;  // default is NO

// Applies a value to raise or lower the voice of the remote peer.
@property(nonatomic) float remoteParticipantVolume; //default 1.0 (max is 1.0, min is 0.0)

// set to YES if you want to use the outputMeterLevel to implement a meter for the output signal.
@property(nonatomic, getter=isOutputMeteringEnabled) BOOL outputMeteringEnabled; //default NO

// set to YES if you want to use the inputMeterLevel to implement a meter for the input (microphone) signal.
@property(nonatomic, getter=isInputMeteringEnabled) BOOL inputMeteringEnabled;  //default NO

// A value in dB to indicate how loud the other participants are at this moment in time.
@property(readonly) float outputMeterLevel;  //changes frequently as the far-end participant speaks

// A value in dB to indicate how loud the the near-end participant is speaking
@property(readonly) float inputMeterLevel;  //changes frequently as the near-end participant speaks

@end

GK_EXTERN	NSString *  const GKVoiceChatServiceErrorDomain;

enum
{
	
	GKVoiceChatServiceInternalError = 32000,	
	GKVoiceChatServiceNoRemotePacketsError = 32001,
	GKVoiceChatServiceUnableToConnectError = 32002,
	GKVoiceChatServiceRemoteParticipantHangupError = 32003,
	GKVoiceChatServiceInvalidCallIDError = 32004,
	GKVoiceChatServiceAudioUnavailableError = 32005,
	GKVoiceChatServiceUninitializedClientError = 32006,
	GKVoiceChatServiceClientMissingRequiredMethodsError = 32007,
	GKVoiceChatServiceRemoteParticipantBusyError = 32008,
	GKVoiceChatServiceRemoteParticipantCancelledError = 32009,
	GKVoiceChatServiceRemoteParticipantResponseInvalidError = 32010,
	GKVoiceChatServiceRemoteParticipantDeclinedInviteError = 32011,
	GKVoiceChatServiceMethodCurrentlyInvalidError = 32012,
	GKVoiceChatServiceNetworkConfigurationError = 32013,
	GKVoiceChatServiceUnsupportedRemoteVersionError = 32014,
	GKVoiceChatServiceOutOfMemoryError = 32015,
	GKVoiceChatServiceInvalidParameterError = 32016
	
};

typedef NSUInteger GKVoiceChatServiceError;