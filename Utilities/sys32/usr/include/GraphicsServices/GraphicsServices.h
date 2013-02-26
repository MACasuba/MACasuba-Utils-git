#ifndef GRAPHICSSERVICES_H
#define GRAPHICSSERVICES_H

#include <CoreGraphics/CoreGraphics.h>
#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

enum {
    kGSEventTypeOneFingerDown = 1,
    kGSEventTypeAllFingersUp = 2,
    kGSEventTypeOneFingerUp = 5,
    kGSEventTypeGesture = 6
} GSEventType;

struct __GSEvent;
typedef struct __GSEvent GSEvent;
typedef GSEvent *GSEventRef;

int GSEventIsChordingHandEvent(GSEventRef ev);
int GSEventGetClickCount(GSEventRef ev);
CGRect GSEventGetLocationInWindow(GSEventRef ev);
float GSEventGetDeltaX(GSEventRef ev);
float GSEventGetDeltaY(GSEventRef ev);
CGPoint GSEventGetInnerMostPathPosition(GSEventRef ev);
CGPoint GSEventGetOuterMostPathPosition(GSEventRef ev);
unsigned int GSEventGetSubType(GSEventRef ev);
unsigned int GSEventGetType(GSEventRef ev);
int GSEventDeviceOrientation(GSEventRef ev);

typedef enum {
    kGSFontTraitNone = 0,
    kGSFontTraitItalic = 1,
    kGSFontTraitBold = 2,
    kGSFontTraitBoldItalic = (kGSFontTraitBold | kGSFontTraitItalic)
} GSFontTrait;

struct __GSFont;
typedef struct __GSFont *GSFontRef;

GSFontRef GSFontCreateWithName(const char *name, GSFontTrait traits, float size);
const char *GSFontGetFamilyName(GSFontRef font);
const char *GSFontGetFullName(GSFontRef font);
bool GSFontIsBold(GSFontRef font);
bool GSFontIsFixedPitch(GSFontRef font);
GSFontTrait GSFontGetTraits(GSFontRef font);

CGColorRef GSColorCreate(CGColorSpaceRef colorspace, const float components[]);
CGColorRef GSColorCreateBlendedColorWithFraction(CGColorRef color, CGColorRef blendedColor, float fraction);
CGColorRef GSColorCreateColorWithDeviceRGBA(float red, float green, float blue, float alpha);
CGColorRef GSColorCreateWithDeviceWhite(float white, float alpha);
CGColorRef GSColorCreateHighlightWithLevel(CGColorRef originalColor, float highlightLevel);
CGColorRef GSColorCreateShadowWithLevel(CGColorRef originalColor, float shadowLevel);

float GSColorGetRedComponent(CGColorRef color);
float GSColorGetGreenComponent(CGColorRef color);
float GSColorGetBlueComponent(CGColorRef color);
float GSColorGetAlphaComponent(CGColorRef color);
const float *GSColorGetRGBAComponents(CGColorRef color);

void GSColorSetColor(CGColorRef color);
void GSColorSetSystemColor(CGColorRef color);

#ifdef __cplusplus
}
#endif

#endif

