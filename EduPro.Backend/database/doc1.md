core.mjs:6531 ERROR RuntimeError: NG01350: 
    ngModel cannot be used to register form controls with a parent formGroup directive.  Try using
    formGroup's partner directive "formControlName" instead.  Example:

    
  <div [formGroup]="myGroup">
    <input formControlName="firstName">
  </div>

  In your class:

  this.myGroup = new FormGroup({
      firstName: new FormControl()
  });

    Or, if you'd like to avoid registering this form control, indicate that it's standalone in ngModelOptions:

    Example:

    
  <div [formGroup]="myGroup">
      <input formControlName="firstName">
      <input [(ngModel)]="showMoreControls" [ngModelOptions]="{standalone: true}">
  </div>

    at modelParentException (forms.mjs:3919:10)
    at _NgModel._checkParentType (forms.mjs:4289:15)
    at _NgModel._checkForErrors (forms.mjs:4280:12)
    at _NgModel.ngOnChanges (forms.mjs:4204:10)
    at _NgModel.rememberChangeHistoryAndInvokeOnChangesHook (core.mjs:4101:14)
    at callHookInternal (core.mjs:5136:14)
    at callHook (core.mjs:5167:9)
    at callHooks (core.mjs:5118:17)
    at executeInitAndCheckHooks (core.mjs:5068:9)
    at selectIndexInternal (core.mjs:11029:17)
handleError	@	core.mjs:6531
(anonymous)	@	core.mjs:31954
invoke	@	zone.js:369
run	@	zone.js:111
runOutsideAngular	@	core.mjs:14778
(anonymous)	@	core.mjs:31954
_tick	@	core.mjs:31541
tick	@	core.mjs:31521
(anonymous)	@	core.mjs:31902
invoke	@	zone.js:369
onInvoke	@	core.mjs:14882
invoke	@	zone.js:368
run	@	zone.js:111
run	@	core.mjs:14733
next	@	core.mjs:31901
ConsumerObserver2.next	@	Subscriber.js:96
Subscriber2._next	@	Subscriber.js:63
Subscriber2.next	@	Subscriber.js:34
(anonymous)	@	Subject.js:41
errorContext	@	errorContext.js:19
Subject2.next	@	Subject.js:31
emit	@	core.mjs:6845
checkStable	@	core.mjs:14801
onHasTask	@	core.mjs:14899
hasTask	@	zone.js:422
_updateTaskCount	@	zone.js:443
_updateTaskCount	@	zone.js:264
runTask	@	zone.js:177
drainMicroTaskQueue	@	zone.js:581
invokeTask	@	zone.js:487
invokeTask	@	zone.js:1138
globalCallback	@	zone.js:1181
globalZoneAwareCallback	@	zone.js:1202

chunk-T4QU4GDF.js?v=765eb8a6:48 ERROR RuntimeError: NG01350: 
    ngModel cannot be used to register form controls with a parent formGroup directive.  Try using
    formGroup's partner directive "formControlName" instead.  Example:

    
  <div [formGroup]="myGroup">
    <input formControlName="firstName">
  </div>

  In your class:

  this.myGroup = new FormGroup({
      firstName: new FormControl()
  });

    Or, if you'd like to avoid registering this form control, indicate that it's standalone in ngModelOptions:

    Example:

    
  <div [formGroup]="myGroup">
      <input formControlName="firstName">
      <input [(ngModel)]="showMoreControls" [ngModelOptions]="{standalone: true}">
  </div>

    at modelParentException (forms.mjs:3919:10)
    at _NgModel._checkParentType (forms.mjs:4289:15)
    at _NgModel._checkForErrors (forms.mjs:4280:12)
    at _NgModel.ngOnChanges (forms.mjs:4204:10)
    at _NgModel.rememberChangeHistoryAndInvokeOnChangesHook (core.mjs:4101:14)
    at callHookInternal (core.mjs:5136:14)
    at callHook (core.mjs:5167:9)
    at callHooks (core.mjs:5118:17)
    at executeCheckHooks (core.mjs:5049:5)
    at selectIndexInternal (core.mjs:11023:17)