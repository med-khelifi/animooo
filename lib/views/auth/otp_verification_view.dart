import 'package:animooo/controllers/auth_controller.dart';
import 'package:animooo/core/enums/otp_flow.dart';
import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_fonts.dart';
import 'package:animooo/core/resources/app_sizes.dart';
import 'package:animooo/core/resources/app_strings.dart';
import 'package:animooo/core/widgets/custom_button.dart';
import 'package:animooo/core/widgets/custom_text.dart';
import 'package:animooo/views/auth/widgets/create_new_password_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:gap/gap.dart';

class OtpVerificationView extends StatefulWidget {
  const OtpVerificationView({super.key});

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  late AuthController _authController;
  late String _email;
  late OtpFlow _otpFlow;
  @override
  void initState() {
    super.initState();
    _authController = AuthController();
    _authController.startResendCodeTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    _email = args["email"];
    _otpFlow = args["otpFlow"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CreateNewPasswordAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppPadding.pw10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: AppStrings.otpVerification,
                fontFamily: AppFonts.otamaEp,
                fontWeight: FontWeight.bold,
                fontSize: AppFontSize.f20,
                color: AppColors.primary,
              ),
              Gap(AppHeight.h8),
              CustomText(
                text: AppStrings.otpVerificationDes,
                fontFamily: AppFonts.poppins,
                fontSize: AppFontSize.f14,
                color: AppColors.secondary,
                fontWeight: FontWeight.w400,
              ),
              Gap(AppHeight.h54),
              Form(
                key: _authController.otpFormKey,
                child: FormField<String>(
                  validator: _authController.validateOtpCode,
                  builder: (field) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        OtpTextField(
                          numberOfFields: 5,
                          margin: EdgeInsetsGeometry.symmetric(
                            horizontal: AppPadding.pw8,
                          ),
                          showFieldAsBox: true,
                          fieldWidth: AppWidth.w52,
                          fieldHeight: AppHeight.h54,
                          borderColor: AppColors.secondary,
                          borderRadius: BorderRadius.circular(AppRadius.r10),
                          focusedBorderColor: AppColors.primary,
                          onSubmit: (value) {
                            field.didChange(value);
                            field.validate();
                            _authController.onOtpCodeSubmitted(value);
                          },
                        ),
                        if (field.hasError)
                          Padding(
                            padding: EdgeInsets.only(top: AppPadding.ph8),
                            child: CustomText(
                              text: field.errorText ?? "error",
                              color: AppColors.red,
                              fontSize: AppFontSize.f12,
                              fontFamily: AppFonts.poppins,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              Gap(AppHeight.h40),
              CustomButton(
                text: AppStrings.confirm,
                onPressed: () =>
                    _authController.verifyOtpCode(context, _email, _otpFlow),
              ),
              Align(
                alignment: Alignment.center,
                child: StreamBuilder<int>(
                  stream: _authController.otpCounterStream,
                  builder: (context, snapshot) {
                    final seconds = snapshot.data ?? 30; // start from 30

                    final formatted =
                        "in 00:${seconds.toString().padLeft(2, '0')}";

                    return GestureDetector(
                      onTap: () {
                        if (seconds == 0) {
                          _authController.resendOtpCode(
                            context,
                            _email,
                            restartTimer: true,
                          );
                        }
                      },
                      child: CustomText(
                        text: seconds == 0
                            ? AppStrings.resendCode
                            : "${AppStrings.resendCode} $formatted",
                        fontFamily: AppFonts.poppins,
                        fontSize: AppFontSize.f12,
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
