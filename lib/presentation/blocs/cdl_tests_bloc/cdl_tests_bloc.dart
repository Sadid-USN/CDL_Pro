import 'package:cdl_pro/presentation/blocs/cdl_tests_bloc/cdl_tests.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class CDLTestsBloc extends Bloc<AbstractCDLTestsEvent, TranslateState> {
  late final OnDeviceTranslator translator;

  CDLTestsBloc() : super(TranslateState.initial()) {
   

   
  }


}
