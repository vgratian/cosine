
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <sys/wait.h>
#include <sys/resource.h>

void help() {
    printf(
    "measure - Run command and print used system resources\n"
    "          similar to time or GNU time utils. See getrusage(2)\n"
    "          for info about the output of this program\n"
    "\n"
    "Usage:\n"
    "       ./measure COMMAND [ARG0 ... ARGN]\n"
    "\n"
    "Output:\n"
    " If command was executed succesfully, then output of the\n"
    " command is followed by a line of numbers showing usage\n"
    " of these resources:\n"
    " - utime stime maxrss minflt majflt inblock oublock nvcsw nivcsw\n"
    "\n"
    " If command failed, then program exits with the exit status\n"
    " of the command.\n"
    "\n"
    "Resources:\n"
    " - ttime         Total CPU time used (utime + stime)\n"
    " - utime         User CPU time in seconds (microsecond precision)\n"
    " - stime         System CPU time in seconds (microsecond precision)\n"
    " - maxrss        Maximum Resident Set Size in kilobytes\n"
    " - minflt        Soft page faults\n"
    " - majflt        Hard page faults\n"
    " - inblock       Block input operations via file system\n"
    " - oublock       Block output operations via file system\n"
    " - nvcsw         Voluntary context switches\n"
    " - nivcsw        Involuntary context switches\n"
    "\n"
    "Examples:\n"
    "  $ ./measure -h (prints this message)\n"
    "  $ ./measure ls -la\n"
    "  $ ./measure expr 365 \\* 24 \\* 60 \\* 60\n");
}

void show_rusage() {
    struct rusage r;
    double ttime;
    if (getrusage(RUSAGE_CHILDREN, &r) == -1) {
        perror("getrusage");
        exit(EXIT_FAILURE);
    }

    ttime = (r.ru_utime.tv_sec + r.ru_stime.tv_sec);
    ttime += ((r.ru_utime.tv_usec + r.ru_stime.tv_usec) / 1000000.0);

    printf(" %f", ttime);
    printf(" %d.%d", r.ru_utime.tv_sec, r.ru_utime.tv_usec);
    printf(" %d.%d", r.ru_stime.tv_sec, r.ru_stime.tv_usec);
    printf(" %d", r.ru_maxrss);
    printf(" %d", r.ru_minflt);
    printf(" %d", r.ru_majflt);
    printf(" %d", r.ru_inblock);
    printf(" %d", r.ru_oublock);
    printf(" %d", r.ru_nvcsw);
    printf(" %d\n", r.ru_nivcsw);
}

int main(int argc, char *argv[]) {

    int child_status, i;
    char *child_argv[argc];
    pid_t child_pid;

    // check arguments, at least one argument should be provided
    if (argc == 1) {
        printf("Usage: %s COMMAND [ARG0 ... ARGN]\n", argv[0]);
        exit(1);
    } else if ( strcmp(argv[1], "-h") == 0 || strcmp(argv[1], "--help") == 0) {
        help();
        exit(0);
    }

    // new argument vector for the child to execute
    for (i=0; i<argc-1; i++) {
        child_argv[i] = argv[i+1];
    }
    child_argv[i] = NULL;
    // parse basename of command
    if ( (child_argv[0] = strrchr(argv[1], '/')) != NULL)
        child_argv[0]++; // strip "/"
    else
        child_argv[0] = argv[1];

    // fork and let the child run the command
    switch (fork()) {
    case -1: // fork failed
        perror("fork");
        exit(EXIT_FAILURE);
    case 0: // child
        execvp(argv[1], child_argv);
        perror("execvp");
        exit(EXIT_FAILURE);
    default: // parent
        break;
    }

    // parent waits for child
    if ( (child_pid = wait(&child_status)) == -1) {
            perror("wait");
            exit(EXIT_FAILURE);
    } else if (child_status != 0) {
        printf("FAIL: Child [%d] exited (%d)\n", child_pid, child_status);
        exit(child_status);
    } else {
        //printf("DONE: Child [%d] exited (%d)\n", child_pid, child_status);
        show_rusage();
    }

    return 0;
}
