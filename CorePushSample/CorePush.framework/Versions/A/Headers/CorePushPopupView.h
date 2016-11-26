//
//  CorePushPopupView.m
//  CorePush
//
//  Copyright (c) 2012 株式会社ブレスサービス. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {
    CorePushPopupViewButtonsAlignmentLeft,
    CorePushPopupViewButtonsAlignmentRight,
    CorePushPopupViewButtonsAlignmentCenter
} ButtonAlignment;


@protocol CorePushPopupViewDelegate;


/**
 * リッチ通知用のポップアップビュー
 */
@interface CorePushPopupView : UIView {
    float _transitionDuration;

    int _borderWidth;
    int _cornerRadius;
    float _borderAlpha;
    UIColor *_borderColor;
    UIColor *_outsideBackcolor;
    float _outsideAlpha;
    BOOL _closeOnTapOutside;
    
    UIView *_titleBarView;
    UIColor *_titleBarBackColor;
    UILabel *_titleBarLabel;
    NSString *_titleBarText;
    UIColor *_titleBarTextColor;
    UIFont *_titleBarFont;
    float _titleBarHeight;
    BOOL _titleBarCloseButtonVisible;
    BOOL _titleBarVisible;
    
    BOOL _buttonsViewVisible;
    UIView* _buttonsView;                
    float _buttonsViewHeight;           
    float _buttonHeight;               
    float _buttonWidth;
    float _buttonsPadding;
    ButtonAlignment _buttonsAlignment;
    UIColor *_buttonsViewBackColor;    
    UIFont* _buttonFont;               
    UIColor *_buttonTextColor;         
    NSMutableArray *_buttonsTitleList; 
    NSMutableArray *_buttonsList;      
    
    
    UIButton *_closeButton;
    
    UIView *_border;           
    UIView *_outsideView;      
    UIButton *_tapButton;      
    
    UIView *_parentView;      
    UIView *_contentView;
    
    id<CorePushPopupViewDelegate> _delegate;
}

#pragma mark -
#pragma mark Properties

/// タイトルバーのテキスト
@property(nonatomic,retain) NSString *titleBarText;


/// コンテンツビュー
@property(nonatomic,readonly) UIView *contentView;


/// CorePushPopupViewDelegateプロトコルを実装したクラス
@property(nonatomic,assign) id<CorePushPopupViewDelegate> delegate;

#pragma mark -
#pragma mark Public Methods

/**
 *  ポップアップビューを初期化する
 *
 *  @param frame  ポップアップビューのフレームサイズ
 *  @param parent ポップアップビューが追加される親ビュー
 */
-(id) initWithFrame:(CGRect)frame withParentView:(UIView*) parent;

/**
 *  ポップアップビューを表示する
 */
-(void) show;

/**
 *  ポップアップビューを非表示する
 */
-(void) hide;


/**
 * レイアウトを構築する。ポップアップビューを表示する前に呼び出す必要がある。
 */
-(void) buildLayoutSubViews;

@end

#pragma mark -
#pragma mark Protocol

@protocol CorePushPopupViewDelegate<NSObject>
@optional
/**
 *  コンテンツビューの外側をユーザーがタップした時に呼び出される
 *  @param popup  ポップアップビュー
 */
-(void) popupDidTapOutside:(CorePushPopupView*) popup;
/**
 *  ポップアップビューが表示された後に呼び出される。
 *  @param popup  ポップアップビュー
 */
-(void) popupDidAppear:(CorePushPopupView*) popup; 
/**
 *  ポップアップビューが非表示になった後に呼びさされる。
 *  @param popup  ポップアップビュー
 */
-(void) popupDidDisappear:(CorePushPopupView*) popup;
/**
 *  ポップアップビューが表示される前に呼び出される。
 *  @param popup  ポップアップビュー
 */
-(void) popupWillAppear:(CorePushPopupView*) popup; 

@end
