#include <stddef.h>
#include <string.h>

void *memset(void *dst, int c, size_t n) {
  char *p = (char *)dst;
  while (n--)
    *p++ = c;
  return dst;
}

size_t strlen(const char *s) {
  char *p = (char *)s;
  while (*p)
    p++;
  return p - s;
}

char *strcpy(char *dst, const char *src) {
  char *p = dst;
  while (1) {
    *p++ = *src;
    if (*src++ == '\0')
      return dst;
  }
}