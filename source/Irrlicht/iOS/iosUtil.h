#pragma once
#include "platform_util.h"

bool isPad();
void getScreenSize(int* width, int* height);

void showJoystick();
void hideJoystick();

void showAds();
void closeAds();

void showSetting();
void closeSetting();
int isSettingShow();
void changeSettingOrientation(int o);

