#include <CoreFoundation/CoreFoundation.h>
#include <IOKit/IOKitLib.h>
#include <IOKit/IOMessage.h>
#include <IOKit/pwr_mgt/IOPM.h>
#include <spawn.h>
#include <stdint.h>
#include <stdio.h>
#include <sys/wait.h>

extern char **environ;

static void display_sleep_now(void) {
  char *argv[] = {"/usr/bin/pmset", "displaysleepnow", NULL};
  pid_t pid;
  if (posix_spawn(&pid, argv[0], NULL, NULL, argv, environ) != 0) {
    perror("posix_spawn pmset");
    return;
  }
  waitpid(pid, NULL, 0);
}

static void on_root_domain_message(void *refcon __unused,
                                   io_service_t service __unused,
                                   natural_t type, void *argument) {
  if (type != kIOPMMessageClamshellStateChange)
    return;
  if (((uintptr_t)argument & kClamshellStateBit) != 0)
    display_sleep_now();
}

int main(void) {
  io_service_t root_domain = IOServiceGetMatchingService(
      kIOMainPortDefault, IOServiceMatching("IOPMrootDomain"));
  if (root_domain == IO_OBJECT_NULL) {
    fprintf(stderr, "IOPMrootDomain not found\n");
    return 1;
  }

  IONotificationPortRef port = IONotificationPortCreate(kIOMainPortDefault);
  io_object_t notifier;
  kern_return_t kr = IOServiceAddInterestNotification(
      port, root_domain, kIOGeneralInterest, on_root_domain_message, NULL,
      &notifier);
  if (kr != KERN_SUCCESS) {
    fprintf(stderr, "IOServiceAddInterestNotification failed: 0x%x\n", kr);
    return 1;
  }

  CFRunLoopAddSource(CFRunLoopGetCurrent(),
                     IONotificationPortGetRunLoopSource(port),
                     kCFRunLoopDefaultMode);
  CFRunLoopRun();
  return 0;
}
