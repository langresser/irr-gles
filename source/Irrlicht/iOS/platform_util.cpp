#include "platform_util.h"
#include <locale>
#include <string.h>

#ifdef __IPHONEOS__
#include "iosUtil.h"
char g_application_dir[256] = {0};
char g_resource_dir[256] = "../Documents/";
#elif defined __ANDROID__
char g_application_dir[256] = {0};
char g_resource_dir[256] = "/sdcard/sdlpal/";
#else
char g_application_dir[256] = {0};
char g_resource_dir[256] = {0};
#endif

char*   my_strlwr(   char*   str   )
{
    char*   orig   =   str;
    //   process   the   string
    for   (   ;   *str   != '\0';   str++   )
        *str   =   tolower(*str);
    return   orig;
}

std::string getFileName(const char* path)
{
    std::string temp = path;
    return temp.substr(temp.rfind('/') + 1);
}

std::string getFullPath(const char* fileName)
{
    std::string temp = g_resource_dir;
    temp += fileName;
    return temp;
}

FILE* open_file(const char* file_name, const char* read_mode)
{
#ifdef WIN32
	FILE* fpx = fopen(file_name, read_mode);
	if (fpx) {
		return fpx;
	}
#ifdef _DEBUG
	printf("open: %s fail\n", file_name);
#endif
	return NULL;
#endif

    char szFileName[256] = {0};
	char szTemp[256] = {0};
	FILE* fp = NULL;
    
    // ����·��
    if (file_name[0] == '/') {
        return fopen(file_name, read_mode);
    }

	strncpy(szFileName, file_name, sizeof(szFileName) - 1);
    my_strlwr(szFileName);

	// �Ȳ�����ԴĿ¼����ԴĿ¼Ҫ���ǿ��Զ�д�ġ��������ͬ�ļ������ȶ�ȡ��ԴĿ¼�µġ��������ļ���
	snprintf(szTemp, sizeof(szTemp) - 1, "%s%s", g_resource_dir, szFileName);
//    printf("%s\n", szTemp);
	
	fp = fopen(szTemp, read_mode);

	if (fp) {
		return fp;
	}
    
#ifdef __IPHONEOS__
    // д�ļ�ֻ��д��documentĿ¼
    if (strchr(read_mode, 'w') != 0) {
        fp = fopen(szTemp, read_mode);
        if (fp) {
            return fp;
        }

		// ���ⲿ���������Ĵ浵������Ϊ�ļ���������mobile�����޷�д�롣ɾ�����ļ������´������ļ�
        remove(szTemp);
		fp = fopen(szTemp, read_mode);
        if (fp) {
            return fp;
        }

        return NULL;
    }
#endif

#ifdef __ANDROID__
    return NULL;
#endif

	snprintf(szTemp, sizeof(szTemp) - 1, "%s%s", g_application_dir, szFileName);
	fp = fopen(szTemp, read_mode);
	if (fp) {
		return fp;
	}
    
#ifdef _DEBUG
    printf("open: %s fail\n", file_name);
#endif

	return NULL;
}

#ifdef WIN32
#include <windows.h>
#pragma comment(lib, "winmm.lib")
#else
#include <sys/time.h>
#endif
unsigned int TimeGet()
{
#ifdef WIN32
	return timeGetTime();
#else
	struct timeval start;
	gettimeofday(&start, NULL);
	unsigned int dwTime = start.tv_sec * 1000 + start.tv_usec / 1000;
	return dwTime;
#endif
}
