
#include <string.h>

int strlen(const char *s) {
  char *t;

  for (t = (char *)s; *t++;)
    ;
  return t - s;
}
