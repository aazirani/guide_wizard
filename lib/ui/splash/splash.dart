import 'dart:async';

import 'package:boilerplate/constants/assets.dart';
import 'package:boilerplate/di/components/service_locator.dart';
import 'package:boilerplate/utils/routes/routes.dart';
import 'package:boilerplate/widgets/app_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boilerplate/stores/step/steps_store.dart';
import 'package:boilerplate/data/repository.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>
      _SplashScreenState(getIt<Repository>());
}

class _SplashScreenState extends State<SplashScreen> {
  late StepsStore _stepsStore;
  Repository _repository;
  _SplashScreenState(Repository repo) : this._repository = repo;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initializing stores
    _stepsStore = Provider.of<StepsStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(child: AppIconWidget(image: Assets.appLogo)),
    );
  }

  startTimer() {
    var _duration = Duration(milliseconds: 1000);
    return Timer(_duration, navigate);
  }

  navigate() async {
    if (!_stepsStore.loading) {
      await _repository.truncateTask();
      await _repository.truncateStep();
      await _stepsStore.getSteps();
    }
    Navigator.of(context).pushReplacementNamed(Routes.home);
  }
}
