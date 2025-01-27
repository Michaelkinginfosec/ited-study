// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ited_study/feature/auth/presentation/views/change_password_screen.dart';
import 'package:ited_study/feature/auth/presentation/views/country_and_school.dart';
import 'package:ited_study/feature/auth/presentation/views/edit_profile_screen.dart';
import 'package:ited_study/feature/auth/presentation/views/forgot_password_screen.dart';
import 'package:ited_study/feature/auth/presentation/views/login_screen.dart';
import 'package:ited_study/feature/auth/presentation/views/sign_up_screen.dart';
import 'package:ited_study/feature/auth/presentation/views/verification_screen.dart';
import 'package:ited_study/feature/gpa/presentation/calculate_cgpa_screen.dart';
import 'package:ited_study/feature/gpa/presentation/cgpa_screen.dart';
import 'package:ited_study/feature/auth/presentation/views/about_us.dart';
import 'package:ited_study/feature/auth/presentation/views/nav_screen.dart';
import 'package:ited_study/feature/notes/presentation/views/course_note_screen.dart';
import 'package:ited_study/feature/notes/presentation/views/notes_screen.dart';
import 'package:ited_study/feature/pastQuestions/presentation/views/cbt_practice.dart';
import 'package:ited_study/feature/pastQuestions/presentation/views/exam.dart';
import 'package:ited_study/feature/pastQuestions/presentation/views/exam_cbt_mode.dart';
import 'package:ited_study/feature/pastQuestions/presentation/views/test.dart';
import 'package:ited_study/feature/onboarding_screen/onboarding_screen.dart';
import 'package:ited_study/feature/auth/presentation/views/settings_screen.dart';
import '../../feature/auth/presentation/views/activate_app_screen.dart';
import '../../feature/auth/presentation/views/home_screen.dart';
import '../../feature/auth/presentation/views/scholarship_screen.dart';
import '../../feature/notes/presentation/views/course_screen.dart';
import '../../feature/pastQuestions/presentation/views/examquestion.dart';
import '../../feature/pastQuestions/presentation/views/general_screen.dart';
import '../../feature/pastQuestions/presentation/views/testquestion.dart';
import 'route.dart';

final box = Hive.box('sessionBox');
var loggedInUser = box.get('token');
bool loggedIn = loggedInUser != null ? true : false;
final router = GoRouter(
  initialLocation: loggedIn ? AppRoutes.home : AppRoutes.onboarding,
  // initialLocation: AppRoutes.navscreen,
  routes: [
    GoRoute(
      name: "/onboarding",
      path: AppRoutes.onboarding,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: OnboardingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeIn;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      name: '/navscreen',
      path: AppRoutes.navscreen,
      redirect: (context, state) {
        if (loggedIn) {
          return AppRoutes.navscreen;
        }
        return null; // Stay on the onboarding page if not logged in
      },
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: NavScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeIn;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      name: '/home',
      path: AppRoutes.home,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeIn;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      name: '/aboutus',
      path: AppRoutes.aboutus,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: AboutUs(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeIn;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      name: '/settings',
      path: AppRoutes.settings,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: SetttingsScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeIn;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      name: '/login',
      path: AppRoutes.login,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeIn;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      name: '/activate',
      path: AppRoutes.activate,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: ActivateAppScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeIn;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      name: '/forgotpassword',
      path: AppRoutes.forgotpassword,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: ForgotPasswordScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeIn;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      name: '/cgpa',
      path: AppRoutes.cgpascreen,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: CGPAScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeIn;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      name: '/calculatecgpa',
      path: AppRoutes.calculatecgpa,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: CalculateCGPAScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeIn;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      name: 'scholarship',
      path: AppRoutes.scholarship,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: ScholarshipScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeIn;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      name: 'editprofile',
      path: AppRoutes.editprofile,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: EditProfileScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeIn;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      name: 'changepassword',
      path: AppRoutes.changepassword,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: ChangePasswordScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeIn;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      name: '/course',
      path: AppRoutes.course,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: CourseScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeIn;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      name: '/note',
      path: AppRoutes.note,
      pageBuilder: (context, state) {
        final topicId = state.extra as String? ?? '';
        return CustomTransitionPage(
          key: state.pageKey,
          child: NotesScreen(
            topicId: topicId,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeIn;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      name: '/coursenote',
      path: AppRoutes.coursenote,
      pageBuilder: (context, state) {
        final courseData = state.extra as Map<String, dynamic>? ?? {};
        final courseTitle = courseData['courseTitle'] as String? ?? '';
        final courseCode = courseData['courseCode'] as String? ?? '';
        final courseId = courseData['courseId'] as String? ?? '';
        return CustomTransitionPage(
          key: state.pageKey,
          child: CourseNoteScreen(
            courseTitle: courseTitle,
            courseCode: courseCode,
            courseId: courseId,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeIn;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      name: '/school',
      path: AppRoutes.school,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: CountryAndSchoolScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeIn;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      name: '/verification',
      path: AppRoutes.verification,
      pageBuilder: (context, state) {
        final email = state.extra as String? ?? '';
        return CustomTransitionPage(
          key: state.pageKey,
          child: VerificationScreen(email: email),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeIn;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
      },
      // builder: (context, state) {
      //   final email = state.extra as String? ?? '';
      //   return VerificationScreen(email: email);
      // },
    ),
    GoRoute(
      name: '/signup',
      path: AppRoutes.signUp,
      pageBuilder: (context, state) {
        final school = state.extra as String? ?? '';
        return CustomTransitionPage(
          key: state.pageKey,
          child: SignUpScreen(school: school),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeIn;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
      },
      builder: (context, state) {
        final school = state.extra as String? ?? '';
        return SignUpScreen(
          school: school,
        );
      },
    ),
    GoRoute(
      name: '/general',
      path: AppRoutes.general,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: GeneralScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeIn;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      name: '/testquestion',
      path: AppRoutes.testquestion,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: TestQuestion(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeIn;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      name: '/testquestionscreen',
      path: AppRoutes.testquestionscreen,
      pageBuilder: (context, state) {
        final testData = state.extra as Map<String, dynamic>? ?? {};
        final topicId = testData['topic'] as String? ?? "";
        final selectedYear = testData['year'] as String? ?? "";
        final courseId = testData['course'] as String? ?? "";
        return CustomTransitionPage(
          key: state.pageKey,
          child: PastTestQuestionScreen(
            topicId: topicId,
            selectedYear: selectedYear,
            courseId: courseId,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeIn;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      name: '/examquestion',
      path: AppRoutes.examquestion,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: ExamQuestion(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeIn;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      name: '/examquestionscreen',
      path: AppRoutes.examquestionscreen,
      pageBuilder: (context, state) {
        final testData = state.extra as Map<String, dynamic>? ?? {};
        final topicId = testData['topic'] as String? ?? "";
        final selectedYear = testData['year'] as String? ?? "";
        final courseId = testData['course'] as String? ?? "";
        return CustomTransitionPage(
          key: state.pageKey,
          child: PastExamQuestionScreen(
            topicId: topicId,
            selectedYear: selectedYear,
            courseId: courseId,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeIn;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      name: '/cbtpractice',
      path: AppRoutes.cbtpractice,
      pageBuilder: (context, state) {
        final testData = state.extra as Map<String, dynamic>? ?? {};
        final time = testData['time'] as String? ?? "";
        final lenght = testData['lenght'] as String? ?? "";
        final courseId = testData['course'] as String? ?? "";
        return CustomTransitionPage(
          key: state.pageKey,
          child: CbtPractice(
            lenght: lenght,
            time: time,
            course: courseId,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeIn;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      name: '/cbt',
      path: AppRoutes.cbt,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: ExamCbtMode(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeIn;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
      },
    ),
  ],
);
