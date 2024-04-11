///
///
/// this file contains:
///
///
/// [FTextFormFieldValidator]
///
///
/// extension:
/// [FocusManagerExtension], [FocusNodeExtension]
/// [GlobalKeyExtension]
///
/// [AnimationControllerExtension]
///
/// [BuildContextExtension]
///
///
///
///
///
///
///
///
///
///
part of damath_flutter;


///
///
///
extension FTextFormFieldValidator on TextFormFieldValidator {
  static FormFieldValidator<String> validateNullOrEmpty(
      String validationFailedMessage,
      ) =>
          (value) =>
      value == null || value.isEmpty ? validationFailedMessage : null;
}



///
/// focus manager, focus general, global key
///
extension FocusManagerExtension on FocusManager {
  void unFocus() => primaryFocus?.unfocus();
}

extension FocusNodeExtension on FocusNode {
  VoidCallback addFocusChangedListener(VoidCallback listener) =>
      hasFocus ? listener : FListener.none;
}

//
extension GlobalKeyExtension on GlobalKey {
  RenderBox get renderBox => currentContext?.findRenderObject() as RenderBox;

  Rect get renderRect => renderBox.fromLocalToGlobalRect;

  Offset adjustScaffoldOf(Offset offset) {
    final translation = currentContext
        ?.findRenderObject()
        ?.getTransformTo(null)
        .getTranslation();

    return translation == null
        ? offset
        : Offset(
            offset.dx - translation.x,
            offset.dy - translation.y,
          );
  }
}

//
extension AnimationControllerExtension on AnimationController {
  void forwardReset({double? from}) => forward(from: from).then((_) => reset());

  void resetForward({double? from}) => this
    ..reset()
    ..forward(from: from);
}


///
/// [theme], [themeText], .... , [colorScheme]
/// [sizeMedia], [mediaViewInsets]
/// [isKeyboardShowing]
///
/// [renderBox]
/// [scaffold], [scaffoldMessenger]
/// [navigator]
///
/// [closeKeyboardIfShowing]
/// [showSnackbar], [showSnackbarWithMessage]
/// [showDialogGenericStyle1], [showDialogGenericStyle2], [showDialogListAndGetItem], [showDialogDecideTureOfFalse]
///
extension BuildContextExtension on BuildContext {
  // AppLocalizations get loc => AppLocalizations.of(this)!;

  ///
  ///
  ///
  ///
  /// theme
  ///
  ///
  ///
  ///

  ThemeData get theme => Theme.of(this);

  TargetPlatform get platform => theme.platform;

  IconThemeData get themeIcon => theme.iconTheme;

  TextTheme get themeText => theme.textTheme;

  AppBarTheme get themeAppBar => theme.appBarTheme;

  BadgeThemeData get themeBadge => theme.badgeTheme;

  MaterialBannerThemeData get themeBanner => theme.bannerTheme;

  BottomAppBarTheme get themeBottomAppBar => theme.bottomAppBarTheme;

  BottomNavigationBarThemeData get themeBottomNavigationBar =>
      theme.bottomNavigationBarTheme;

  BottomSheetThemeData get themeBottomSheet => theme.bottomSheetTheme;

  ButtonBarThemeData get themeButtonBar => theme.buttonBarTheme;

  ButtonThemeData get themeButton => theme.buttonTheme;

  CardTheme get themeCard => theme.cardTheme;

  CheckboxThemeData get themeCheckbox => theme.checkboxTheme;

  ChipThemeData get themeChip => theme.chipTheme;

  DataTableThemeData get themeDataTable => theme.dataTableTheme;

  DatePickerThemeData get themeDatePicker => theme.datePickerTheme;

  DialogTheme get themeDialog => theme.dialogTheme;

  DividerThemeData get themeDivider => theme.dividerTheme;

  DrawerThemeData get themeDrawer => theme.drawerTheme;

  DropdownMenuThemeData get themeDropdownMenu => theme.dropdownMenuTheme;

  ElevatedButtonThemeData get themeElevatedButton => theme.elevatedButtonTheme;

  ExpansionTileThemeData get themeExpansionTile => theme.expansionTileTheme;

  FilledButtonThemeData get themeFilledButton => theme.filledButtonTheme;

  FloatingActionButtonThemeData get themeFloatingActionButton =>
      theme.floatingActionButtonTheme;

  IconButtonThemeData get themeIconButton => theme.iconButtonTheme;

  ListTileThemeData get themeListTile => theme.listTileTheme;

  MenuBarThemeData get themeMenuBar => theme.menuBarTheme;

  MenuButtonThemeData get themeMenuButton => theme.menuButtonTheme;

  MenuThemeData get themeMenu => theme.menuTheme;

  NavigationBarThemeData get themeNavigationBar => theme.navigationBarTheme;

  NavigationDrawerThemeData get themeNavigationDrawer =>
      theme.navigationDrawerTheme;

  NavigationRailThemeData get themeNavigationRail => theme.navigationRailTheme;

  OutlinedButtonThemeData get themeOutlinedButton => theme.outlinedButtonTheme;

  PopupMenuThemeData get themePopupMenu => theme.popupMenuTheme;

  ProgressIndicatorThemeData get themeProgressIndicator =>
      theme.progressIndicatorTheme;

  RadioThemeData get themeRadio => theme.radioTheme;

  SearchBarThemeData get themeSearchBar => theme.searchBarTheme;

  SearchViewThemeData get themeSearchView => theme.searchViewTheme;

  SegmentedButtonThemeData get themeSegmentedButton =>
      theme.segmentedButtonTheme;

  SliderThemeData get themeSlider => theme.sliderTheme;

  SnackBarThemeData get themeSnackBar => theme.snackBarTheme;

  SwitchThemeData get themeSwitch => theme.switchTheme;

  TabBarTheme get themeTabBar => theme.tabBarTheme;

  TextButtonThemeData get themeTextButton => theme.textButtonTheme;

  TextSelectionThemeData get themeTextSelection => theme.textSelectionTheme;

  TimePickerThemeData get themeTimePicker => theme.timePickerTheme;

  ToggleButtonsThemeData get themeToggleButtons => theme.toggleButtonsTheme;

  TooltipThemeData get themeTooltip => theme.tooltipTheme;

  ColorScheme get colorScheme => theme.colorScheme;

  ///
  ///
  /// [sizeMedia], [sizeRenderBox]
  ///
  ///
  Size get sizeMedia => MediaQuery.sizeOf(this);

  Size get sizeRenderBox => renderBox.size;

  ///
  ///
  /// [mediaViewInsets], [mediaViewInsetsBottom]
  /// [isKeyboardShowing], [closeKeyboardIfShowing]
  ///
  ///
  EdgeInsets get mediaViewInsets => MediaQuery.viewInsetsOf(this);

  double get mediaViewInsetsBottom => mediaViewInsets.bottom;

  bool get isKeyboardShowing => mediaViewInsetsBottom > 0;

  void closeKeyboardIfShowing() {
    if (isKeyboardShowing) {
      FocusScopeNode currentFocus = FocusScope.of(this);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }
  }

  ///
  ///
  /// [renderBox], [scaffold], [scaffoldMessenger]
  ///
  ///
  RenderBox get renderBox => findRenderObject() as RenderBox;

  ScaffoldState get scaffold => Scaffold.of(this);

  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);

  ///
  ///
  /// [navigator], [pop]
  ///
  ///
  NavigatorState get navigator => Navigator.of(this);

  void pop() => Navigator.pop(this);

  ///
  ///
  /// [defaultTextStyle], [defaultTextStyleMerge], [textDirection]
  ///
  ///
  ///
  DefaultTextStyle get defaultTextStyle => DefaultTextStyle.of(this);

  TextStyle defaultTextStyleMerge(TextStyle? other) {
    final style = defaultTextStyle.style;
    return style.inherit ? style.merge(other) : style;
  }

  TextDirection get textDirection => Directionality.of(this);

  ///
  ///
  ///
  /// snackbar, material banner, dialog
  ///
  ///
  ///

  ///
  ///
  /// [showSnackbar], [showSnackbarWithMessage]
  ///
  ///
  void showSnackbar(SnackBar snackBar) =>
      scaffoldMessenger.showSnackBar(snackBar);

  void showSnackbarWithMessage(
    String? message, {
    bool isCenter = true,
    bool showWhetherMessageIsNull = false,
    Duration duration = KCore.durationSecond1,
    Color? backgroundColor,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
  }) {
    if (showWhetherMessageIsNull || message != null) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          backgroundColor: backgroundColor ?? theme.cardColor,
          behavior: behavior,
          duration: duration,
          content: isCenter
              ? Center(child: Text(message ?? ''))
              : Text(message ?? ''),
        ),
      );
    }
  }

  ///
  ///
  /// [showMaterialBanner], [hideMaterialBanner]
  ///
  ///
  void showMaterialBanner(MaterialBanner banner) =>
      scaffoldMessenger.showMaterialBanner(banner);

  void hideMaterialBanner({
    MaterialBannerClosedReason reason = MaterialBannerClosedReason.dismiss,
  }) =>
      scaffoldMessenger.hideCurrentMaterialBanner(reason: reason);

  ///
  ///
  /// [showDialogGenericStyle1], [showDialogGenericStyle2], [showDialogStyle3]
  /// [showDialogListAndGetItem], [showDialogDecideTureOfFalse]
  ///
  ///
  Future<T?> showDialogGenericStyle1<T>({
    required String title,
    required String content,
    required Supplier<Map<String, T>> optionsBuilder,
  }) {
    final options = optionsBuilder();
    return showDialog(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: options.keys
            .map((optionTitle) => TextButton(
                  onPressed: () => context.navigator.pop(
                    options[optionTitle],
                  ),
                  child: Text(optionTitle),
                ))
            .toList(),
      ),
    );
  }

  Future<T?> showDialogGenericStyle2<T>({
    required String title,
    required String? content,
    required Map<String, T Function()> actionTitleAndActions,
  }) async {
    final actions = <Widget>[];
    T? returnValue;
    actionTitleAndActions.forEach((label, action) {
      actions.add(TextButton(
        onPressed: () {
          navigator.pop();
          returnValue = action();
        },
        child: Text(label),
      ));
    });
    await showDialog(
        context: this,
        builder: (context) => content == null
            ? SimpleDialog(title: Text(title), children: actions)
            : AlertDialog(
                title: Text(title),
                content: Text(content),
                actions: actions,
              ));
    return returnValue;
  }

  void showDialogStyle3(
    String text,
    VoidCallback? onEnsure, {
    Widget? content,
    String messageEnsure = '確認',
  }) {
    showDialog<void>(
      context: this,
      builder: (context) {
        return AlertDialog(
          content: content ?? Text(text),
          actions: [
            if (onEnsure != null)
              TextButton(
                onPressed: onEnsure,
                child: Text(messageEnsure),
              ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('關閉'),
            ),
          ],
        );
      },
    );
  }

  Future<T?> showDialogListAndGetItem<T>({
    required String title,
    required List<T> itemList,
  }) async {
    late final T? selectedItem;
    await showDialog(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          height: 200,
          width: 100,
          child: ListView.builder(
            itemCount: itemList.length,
            itemBuilder: (context, index) {
              final item = itemList[index];
              return Center(
                child: TextButton(
                  onPressed: () {
                    selectedItem = item;
                    context.navigator.pop();
                  },
                  child: Text(item.toString()),
                ),
              );
            },
          ),
        ),
      ),
    );
    return selectedItem;
  }

  Future<bool?> showDialogDecideTureOfFalse(
    Widget iconProcess,
    Widget iconCancel,
  ) async {
    bool? result;
    await showDialog(
        context: this,
        builder: (context) => SimpleDialog(
              children: [
                TextButton(
                  onPressed: () {
                    result = true;
                    context.navigator.pop();
                  },
                  child: iconProcess,
                ),
                TextButton(
                  onPressed: () {
                    result = false;
                    context.navigator.pop();
                  },
                  child: iconCancel,
                ),
              ],
            ));
    return result;
  }
}
