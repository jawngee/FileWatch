//
//  FWHotKey.m
//  FileWatch
//
//  Created by Jon Gilkison on 5/18/18.
//  Copyright © 2018 Jon Gilkison. All rights reserved.
//

#import "FWHotKey.h"
#import "NSDictionary+ILAB.h"
@import Carbon;

@implementation FWHotKey

-(nonnull instancetype)initWithData:(nonnull NSDictionary *)data {
    if ((self = [super init])) {
        BOOL control = [data getModelBool:@"control" default:NO];
        BOOL shift = [data getModelBool:@"shift" default:NO];
        BOOL option = [data getModelBool:@"option" default:NO];
        BOOL command = [data getModelBool:@"command" default:NO];
        BOOL function = [data getModelBool:@"function" default:NO];

        _modifiers = 0;
        
        if (shift) {
            _modifiers = _modifiers | NSEventModifierFlagShift;
        }

        if (control) {
            _modifiers = _modifiers | NSEventModifierFlagControl;
        }

        if (command) {
            _modifiers = _modifiers | NSEventModifierFlagCommand;
        }

        if (option) {
            _modifiers = _modifiers | NSEventModifierFlagOption;
        }

        if (function) {
            _modifiers = _modifiers | NSEventModifierFlagFunction;
        }
        
        _key = [data getModelString:@"key" default:nil];
        if (_key) {
            [self parseKeyCode];
        }
    }
    
    return self;
}

-(void)parseKeyCode {
    unichar upArrowFunctionKey = NSUpArrowFunctionKey;
    unichar downArrowFunctionKey = NSDownArrowFunctionKey;
    unichar leftArrowFunctionKey = NSLeftArrowFunctionKey;
    unichar rightArrowFunctionKey = NSRightArrowFunctionKey;
    unichar f1FunctionKey = NSF1FunctionKey;
    unichar f2FunctionKey = NSF2FunctionKey;
    unichar f3FunctionKey = NSF3FunctionKey;
    unichar f4FunctionKey = NSF4FunctionKey;
    unichar f5FunctionKey = NSF5FunctionKey;
    unichar f6FunctionKey = NSF6FunctionKey;
    unichar f7FunctionKey = NSF7FunctionKey;
    unichar f8FunctionKey = NSF8FunctionKey;
    unichar f9FunctionKey = NSF9FunctionKey;
    unichar f10FunctionKey = NSF10FunctionKey;
    unichar f11FunctionKey = NSF11FunctionKey;
    unichar f12FunctionKey = NSF12FunctionKey;
    unichar backspaceFunctionKey = NSBackspaceCharacter;
    unichar deleteFunctionKey = NSDeleteCharacter;
    unichar homeFunctionKey = NSHomeFunctionKey;
    unichar endFunctionKey = NSEndFunctionKey;
    unichar pageUpFunctionKey = NSPageUpFunctionKey;
    unichar pageDownFunctionKey = NSPageDownFunctionKey;

    
    NSString *k = _key.lowercaseString;
    
    if ([k isEqualToString:@"a"]) { _keyCode = kVK_ANSI_A; }
    else if ([k isEqualToString:@"s"]) { _keyCode = kVK_ANSI_S; }
    else if ([k isEqualToString:@"d"]) { _keyCode = kVK_ANSI_D; }
    else if ([k isEqualToString:@"f"]) { _keyCode = kVK_ANSI_F; }
    else if ([k isEqualToString:@"h"]) { _keyCode = kVK_ANSI_H; }
    else if ([k isEqualToString:@"g"]) { _keyCode = kVK_ANSI_G; }
    else if ([k isEqualToString:@"z"]) { _keyCode = kVK_ANSI_Z; }
    else if ([k isEqualToString:@"x"]) { _keyCode = kVK_ANSI_X; }
    else if ([k isEqualToString:@"c"]) { _keyCode = kVK_ANSI_C; }
    else if ([k isEqualToString:@"v"]) { _keyCode = kVK_ANSI_V; }
    else if ([k isEqualToString:@"b"]) { _keyCode = kVK_ANSI_B; }
    else if ([k isEqualToString:@"q"]) { _keyCode = kVK_ANSI_Q; }
    else if ([k isEqualToString:@"w"]) { _keyCode = kVK_ANSI_W; }
    else if ([k isEqualToString:@"e"]) { _keyCode = kVK_ANSI_E; }
    else if ([k isEqualToString:@"r"]) { _keyCode = kVK_ANSI_R; }
    else if ([k isEqualToString:@"y"]) { _keyCode = kVK_ANSI_Y; }
    else if ([k isEqualToString:@"t"]) { _keyCode = kVK_ANSI_T; }
    else if ([k isEqualToString:@"1"]) { _keyCode = kVK_ANSI_1; }
    else if ([k isEqualToString:@"2"]) { _keyCode = kVK_ANSI_2; }
    else if ([k isEqualToString:@"3"]) { _keyCode = kVK_ANSI_3; }
    else if ([k isEqualToString:@"4"]) { _keyCode = kVK_ANSI_4; }
    else if ([k isEqualToString:@"6"]) { _keyCode = kVK_ANSI_6; }
    else if ([k isEqualToString:@"5"]) { _keyCode = kVK_ANSI_5; }
    else if ([k isEqualToString:@"="]) { _keyCode = kVK_ANSI_Equal; }
    else if ([k isEqualToString:@"9"]) { _keyCode = kVK_ANSI_9; }
    else if ([k isEqualToString:@"7"]) { _keyCode = kVK_ANSI_7; }
    else if ([k isEqualToString:@"-"]) { _keyCode = kVK_ANSI_Minus; }
    else if ([k isEqualToString:@"8"]) { _keyCode = kVK_ANSI_8; }
    else if ([k isEqualToString:@"0"]) { _keyCode = kVK_ANSI_0; }
    else if ([k isEqualToString:@"]"]) { _keyCode = kVK_ANSI_RightBracket; }
    else if ([k isEqualToString:@"o"]) { _keyCode = kVK_ANSI_O; }
    else if ([k isEqualToString:@"u"]) { _keyCode = kVK_ANSI_U; }
    else if ([k isEqualToString:@"["]) { _keyCode = kVK_ANSI_LeftBracket; }
    else if ([k isEqualToString:@"i"]) { _keyCode = kVK_ANSI_I; }
    else if ([k isEqualToString:@"p"]) { _keyCode = kVK_ANSI_P; }
    else if ([k isEqualToString:@"l"]) { _keyCode = kVK_ANSI_L; }
    else if ([k isEqualToString:@"j"]) { _keyCode = kVK_ANSI_J; }
    else if ([k isEqualToString:@"'"]) { _keyCode = kVK_ANSI_Quote; }
    else if ([k isEqualToString:@"k"]) { _keyCode = kVK_ANSI_K; }
    else if ([k isEqualToString:@";"]) { _keyCode = kVK_ANSI_Semicolon; }
    else if ([k isEqualToString:@"\\"]) { _keyCode = kVK_ANSI_Backslash; }
    else if ([k isEqualToString:@","]) { _keyCode = kVK_ANSI_Comma; }
    else if ([k isEqualToString:@"/"]) { _keyCode = kVK_ANSI_Slash; }
    else if ([k isEqualToString:@"n"]) { _keyCode = kVK_ANSI_N; }
    else if ([k isEqualToString:@"m"]) { _keyCode = kVK_ANSI_M; }
    else if ([k isEqualToString:@"."]) { _keyCode = kVK_ANSI_Period; }
    else if ([k isEqualToString:@"`"]) { _keyCode = kVK_ANSI_Grave; }
    else if ([k isEqualToString:@"return"]) { _keyCode = kVK_Return; _key = @"\n"; }
    else if ([k isEqualToString:@"tab"]) { _keyCode = kVK_Tab; _key = @"\t"; }
    else if ([k isEqualToString:@"space"]) { _keyCode = kVK_Space; _key = @" "; }
    else if ([k isEqualToString:@"backspace"]) { _keyCode = kVK_Delete; _key = [NSString stringWithCharacters:&backspaceFunctionKey length:1]; }
    else if ([k isEqualToString:@"delete"]) { _keyCode = kVK_ForwardDelete; _key = [NSString stringWithCharacters:&deleteFunctionKey length:1]; }
    else if ([k isEqualToString:@"esc"]) { _keyCode = kVK_Escape; _key = [NSString stringWithFormat:@"%C", 0x1b]; }
    else if ([k isEqualToString:@"f1"]) { _keyCode = kVK_F1; _key = [NSString stringWithCharacters:&f1FunctionKey length:1]; }
    else if ([k isEqualToString:@"f2"]) { _keyCode = kVK_F2; _key = [NSString stringWithCharacters:&f2FunctionKey length:1]; }
    else if ([k isEqualToString:@"f3"]) { _keyCode = kVK_F3; _key = [NSString stringWithCharacters:&f3FunctionKey length:1]; }
    else if ([k isEqualToString:@"f4"]) { _keyCode = kVK_F4; _key = [NSString stringWithCharacters:&f4FunctionKey length:1]; }
    else if ([k isEqualToString:@"f5"]) { _keyCode = kVK_F5; _key = [NSString stringWithCharacters:&f5FunctionKey length:1]; }
    else if ([k isEqualToString:@"f6"]) { _keyCode = kVK_F6; _key = [NSString stringWithCharacters:&f6FunctionKey length:1]; }
    else if ([k isEqualToString:@"f7"]) { _keyCode = kVK_F7; _key = [NSString stringWithCharacters:&f7FunctionKey length:1]; }
    else if ([k isEqualToString:@"f8"]) { _keyCode = kVK_F8; _key = [NSString stringWithCharacters:&f8FunctionKey length:1]; }
    else if ([k isEqualToString:@"f9"]) { _keyCode = kVK_F9; _key = [NSString stringWithCharacters:&f9FunctionKey length:1]; }
    else if ([k isEqualToString:@"f10"]) { _keyCode = kVK_F10; _key = [NSString stringWithCharacters:&f10FunctionKey length:1]; }
    else if ([k isEqualToString:@"f11"]) { _keyCode = kVK_F11; _key = [NSString stringWithCharacters:&f11FunctionKey length:1]; }
    else if ([k isEqualToString:@"f12"]) { _keyCode = kVK_F12; _key = [NSString stringWithCharacters:&f12FunctionKey length:1]; }
    else if ([k isEqualToString:@"home"]) { _keyCode = kVK_Home; _key = [NSString stringWithCharacters:&homeFunctionKey length:1]; }
    else if ([k isEqualToString:@"end"]) { _keyCode = kVK_End; _key = [NSString stringWithCharacters:&endFunctionKey length:1];}
    else if ([k isEqualToString:@"pgup"]) { _keyCode = kVK_PageUp; _key = [NSString stringWithCharacters:&pageUpFunctionKey length:1];}
    else if ([k isEqualToString:@"pgdn"]) { _keyCode = kVK_PageDown; _key = [NSString stringWithCharacters:&pageDownFunctionKey length:1];}
    else if ([k isEqualToString:@"left"]) { _keyCode = kVK_LeftArrow; _key = [NSString stringWithCharacters:&leftArrowFunctionKey length:1]; }
    else if ([k isEqualToString:@"right"]) { _keyCode = kVK_RightArrow; _key = [NSString stringWithCharacters:&rightArrowFunctionKey length:1]; }
    else if ([k isEqualToString:@"down"]) { _keyCode = kVK_DownArrow; _key = [NSString stringWithCharacters:&downArrowFunctionKey length:1]; }
    else if ([k isEqualToString:@"up"]) { _keyCode = kVK_UpArrow; _key = [NSString stringWithCharacters:&upArrowFunctionKey length:1]; }
}

@end
