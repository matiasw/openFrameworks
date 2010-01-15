#ifndef _TEST_APP
#define _TEST_APP

#define MARGIN 10

//#define USE_LIVE_VIDEO

#include "GLHandles.h"
#include "ofMain.h"
#include "ofxFreeFrame.h"


class testApp : public ofSimpleApp {

	public:

		void setup();
		void update();
		void draw();

		void keyPressed(int key);
		void keyReleased(int key);
		void mouseMoved(int x, int y );
		void mouseDragged(int x, int y, int button);
		void mousePressed(int x, int y, int button);
		void mouseReleased();


        ofxFFGLHost     ffHost;
#ifdef USE_LIVE_VIDEO
        ofVideoGrabber          video;
#else
        ofVideoPlayer           video;
#endif
    
        bool            ffGL_1, ffGL_2, ffGL_3;
        int             vidWidth, vidHeight;

};

#endif
