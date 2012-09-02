//
//  AppDelegate.m
//  ios
//
//  Created by 王 佳 on 12-8-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#include <irrlicht.h>

using namespace irr;

using namespace core;
using namespace scene;
using namespace video;
using namespace io;
using namespace gui;

IrrlichtDevice *g_device = NULL;
IVideoDriver* g_driver = NULL;
ISceneManager* g_smgr = NULL;
IGUIEnvironment* g_guienv = NULL;

void irrGameLoop()
{
    if (!g_device->isWindowActive()) {
        return;
    }
    g_driver->beginScene(true, true, SColor(255,100,101,140));
    
    g_smgr->drawAll();
    g_guienv->drawAll();
    
    g_driver->endScene();
}


@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (void)dealloc
{
    if (g_device) {
        g_device->drop();
        g_device = NULL;
    }

    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    SIrrlichtCreationParameters p;
    p.DriverType = video::EDT_OGLES1;
    p.WindowSize = dimension2d<u32>(640, 480);
    p.Bits = 16;
    p.Fullscreen = true;
    p.Stencilbuffer = true;
    p.Vsync = true;
    p.EventReceiver = 0;
    p.WindowId = _window;

    g_device =
    createDeviceEx(p);
    
	if (!g_device)
		return 1;
    
	/*
     Set the caption of the window to some nice text. Note that there is an
     'L' in front of the string. The Irrlicht Engine uses wide character
     strings when displaying text.
     */
	g_device->setWindowCaption(L"Hello World! - Irrlicht Engine Demo");
    
	/*
     Get a pointer to the VideoDriver, the SceneManager and the graphical
     user interface environment, so that we do not always have to write
     device->getVideoDriver(), device->getSceneManager(), or
     device->getGUIEnvironment().
     */
    g_driver = g_device->getVideoDriver();
    g_smgr = g_device->getSceneManager();
    g_guienv = g_device->getGUIEnvironment();
    
	/*
     We add a hello world label to the window, using the GUI environment.
     The text is placed at the position (10,10) as top left corner and
     (260,22) as lower right corner.
     */
	g_guienv->addStaticText(L"Hello World! This is the Irrlicht Software renderer!",
                          rect<s32>(10,10,260,22), true);
    
	/*
     To show something interesting, we load a Quake 2 model and display it.
     We only have to get the Mesh from the Scene Manager with getMesh() and add
     a SceneNode to display the mesh with addAnimatedMeshSceneNode(). We
     check the return value of getMesh() to become aware of loading problems
     and other errors.
     
     Instead of writing the filename sydney.md2, it would also be possible
     to load a Maya object file (.obj), a complete Quake3 map (.bsp) or any
     other supported file format. By the way, that cool Quake 2 model
     called sydney was modelled by Brian Collins.
     */
	IAnimatedMesh* mesh = g_smgr->getMesh("media/sydney.md2");
	if (!mesh)
	{
		g_device->drop();
		return 1;
	}
	IAnimatedMeshSceneNode* node = g_smgr->addAnimatedMeshSceneNode( mesh );
    
	/*
     To let the mesh look a little bit nicer, we change its material. We
     disable lighting because we do not have a dynamic light in here, and
     the mesh would be totally black otherwise. Then we set the frame loop,
     such that the predefined STAND animation is used. And last, we apply a
     texture to the mesh. Without it the mesh would be drawn using only a
     color.
     */
	if (node)
	{
		node->setMaterialFlag(EMF_LIGHTING, false);
		node->setMD2Animation(scene::EMAT_STAND);
		node->setMaterialTexture( 0, g_driver->getTexture("media/sydney.bmp") );
	}
    
	/*
     To look at the mesh, we place a camera into 3d space at the position
     (0, 30, -40). The camera looks from there to (0,5,0), which is
     approximately the place where our md2 model is.
     */
	g_smgr->addCameraSceneNode(0, vector3df(0,30,-40), vector3df(0,5,0));

    [_window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    g_device->setWindowActive(false);
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    g_device->setWindowActive(true);
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
