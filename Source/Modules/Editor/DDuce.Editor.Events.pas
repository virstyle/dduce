{
  Copyright (C) 2013-2016 Tim Sinaeve tim.sinaeve@gmail.com

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Library General Public License as published by
  the Free Software Foundation; either version 2 of the License, or (at your
  option) any later version.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
  for more details.

  You should have received a copy of the GNU Library General Public License
  along with this library; if not, write to the Free Software Foundation,
  Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
}

unit DDuce.Editor.Events;

{ Events dispatched by the IEditorManager and active IEditorView instance.

  TMethodList is used to emulate multicast events hence these events can be
  dispatched to multiple event handlers. This is an implementation of the
  observer pattern where multiple observers can respond to changes in a subject.
}

interface

uses
  System.Classes, System.SysUtils,

  Spring,

  DDuce.Editor.Types, DDuce.Editor.Interfaces;

type
  TEditorEvents = class(TInterfacedObject, IEditorEvents)
  strict private
    FManager               : IEditorManager;
    FOnChange              : Event<TNotifyEvent>;
    FOnModified            : Event<TNotifyEvent>;
    FOnActiveViewChange    : Event<TNotifyEvent>;
    FOnCaretPositionChange : Event<TCaretPositionEvent>;
    FOnActionExecute       : Event<TActionExecuteEvent>;
    FOnNew                 : Event<TNewEvent>;
    FOnLoad                : Event<TStorageEvent>;
    FOnOpen                : Event<TStorageEvent>;
    FOnBeforeSave          : Event<TStorageEvent>;
    FOnAfterSave           : Event<TStorageEvent>;
    FOnSave                : Event<TStorageEvent>;
    FOnAddEditorView       : Event<TAddEditorViewEvent>;
    FOnShowEditorToolView  : Event<TEditorToolViewEvent>;
    FOnHideEditorToolView  : Event<TEditorToolViewEvent>;
    FOnOpenOtherInstance   : Event<TOpenOtherInstanceEvent>;
    FOnStatusMessage       : Event<TStatusMessageEvent>;

  protected
    function GetOnOpen: IEvent<TStorageEvent>;
    function GetOnAfterSave: IEvent<TStorageEvent>;
    function GetOnBeforeSave: IEvent<TStorageEvent>;
    function GetView: IEditorView;
    function GetOnAddEditorView: IEvent<TAddEditorViewEvent>;
    function GetOnHideEditorToolView: IEvent<TEditorToolViewEvent>;
    function GetOnNew: IEvent<TNewEvent>;
    function GetOnLoad: IEvent<TStorageEvent>;
    function GetOnOpenOtherInstance: IEvent<TOpenOtherInstanceEvent>;
    function GetOnSave: IEvent<TStorageEvent>;
    function GetOnShowEditorToolView: IEvent<TEditorToolViewEvent>;
//    function GetOnStatusChange: TStatusChangeEvent;
    function GetOnActionExecute: IEvent<TActionExecuteEvent>;
    function GetOnCaretPositionChange: IEvent<TCaretPositionEvent>;
    function GetOnActiveViewChange: IEvent<TNotifyEvent>;
    function GetOnChange: IEvent<TNotifyEvent>;
    function GetOnModified: IEvent<TNotifyEvent>;

    { will get called by owner to trigger the events }
    procedure DoChange; virtual;
    procedure DoModified; virtual;
    procedure DoHighlighterChange; virtual;
    procedure DoActiveViewChange; virtual;
    procedure DoAddEditorView(AEditorView: IEditorView); virtual;
    procedure DoShowToolView(AToolView: IEditorToolView); virtual;
    procedure DoHideToolView(AToolView: IEditorToolView); virtual;
    procedure DoCaretPositionChange; virtual;
    procedure DoActionExecute(AAction: TBasicAction; var AHandled: Boolean);
    procedure DoOpenOtherInstance(const AParams: array of string); virtual;
    procedure DoStatusMessage(AText: string); virtual;
//    procedure DoStatusChange(AChanges: TSynStatusChanges); virtual;
    procedure DoOpen(const AName: string);
    procedure DoLoad(const AName: string);
    procedure DoNew(
      const AName : string = '';
      const AText : string = ''
    );

    property OnAddEditorView: IEvent<TAddEditorViewEvent>
      read GetOnAddEditorView;

    property OnShowEditorToolView: IEvent<TEditorToolViewEvent>
      read GetOnShowEditorToolView;

    property OnHideEditorToolView: IEvent<TEditorToolViewEvent>
      read GetOnHideEditorToolView;

//    property OnStatusChange: TStatusChangeEvent
//      read GetOnStatusChange write SetOnStatusChange;

    { Called when content is loaded into the editor's buffer. }
    property OnLoad: IEvent<TStorageEvent>
      read GetOnLoad;

    { Called when the 'New' action is executed by user }
    property OnNew: IEvent<TNewEvent>
      read GetOnNew;

    { Called when the editor's content is about to be saved. }
    property OnSave: IEvent<TStorageEvent>
      read GetOnSave;

    { Called when the 'Open file' action is executed by user. }
    property OnOpen: IEvent<TStorageEvent>
      read GetOnOpen;

    property OnOpenOtherInstance: IEvent<TOpenOtherInstanceEvent>
      read GetOnOpenOtherInstance;

    property OnChange: IEvent<TNotifyEvent>
      read GetOnChange;

    property OnModified: IEvent<TNotifyEvent>
      read GetOnModified;

    property OnActiveViewChange: IEvent<TNotifyEvent>
      read GetOnActiveViewChange;

    property OnActionExecute: IEvent<TActionExecuteEvent>
      read GetOnActionExecute;

    property OnCaretPositionChange: IEvent<TCaretPositionEvent>
      read GetOnCaretPositionChange;

    property View: IEditorView
      read GetView;

  public
    constructor Create(AManager: IEditorManager);
    procedure BeforeDestruction; override;

  end;

implementation

{$REGION 'TEditorEvents'}
{$REGION 'construction and destruction'}
constructor TEditorEvents.Create(AManager: IEditorManager);
begin
  inherited Create;
  FManager := AManager;
end;

procedure TEditorEvents.BeforeDestruction;
begin
  FManager := nil;
  inherited BeforeDestruction;
end;
{$ENDREGION}

{$REGION 'property access mehods'}
function TEditorEvents.GetOnOpen: IEvent<TStorageEvent>;
begin
  Result := FOnOpen;
end;

function TEditorEvents.GetOnAfterSave: IEvent<TStorageEvent>;
begin
  Result := FOnAfterSave;
end;

function TEditorEvents.GetOnBeforeSave: IEvent<TStorageEvent>;
begin
  Result := FOnBeforeSave;
end;

function TEditorEvents.GetOnCaretPositionChange: IEvent<TCaretPositionEvent>;
begin
  Result := FOnCaretPositionChange;
end;

function TEditorEvents.GetOnChange: IEvent<TNotifyEvent>;
begin
  Result := FOnChange;
end;

function TEditorEvents.GetView: IEditorView;
begin
  Result := FManager as IEditorView;
end;

function TEditorEvents.GetOnActionExecute: IEvent<TActionExecuteEvent>;
begin
  Result := FOnActionExecute;
end;

function TEditorEvents.GetOnActiveViewChange: IEvent<TNotifyEvent>;
begin
  Result := FOnActiveViewChange;
end;

function TEditorEvents.GetOnAddEditorView: IEvent<TAddEditorViewEvent>;
begin
  Result := FOnAddEditorView;
end;

function TEditorEvents.GetOnHideEditorToolView: IEvent<TEditorToolViewEvent>;
begin
  Result := FOnHideEditorToolView;
end;

function TEditorEvents.GetOnNew: IEvent<TNewEvent>;
begin
  Result := FOnNew;
end;

function TEditorEvents.GetOnOpenOtherInstance: IEvent<TOpenOtherInstanceEvent>;
begin
  Result := FOnOpenOtherInstance;
end;

function TEditorEvents.GetOnSave: IEvent<TStorageEvent>;
begin
  Result := FOnSave;
end;

function TEditorEvents.GetOnLoad: IEvent<TStorageEvent>;
begin
  Result := FOnLoad;
end;

function TEditorEvents.GetOnModified: IEvent<TNotifyEvent>;
begin
  Result := FOnModified;
end;

function TEditorEvents.GetOnShowEditorToolView: IEvent<TEditorToolViewEvent>;
begin
  Result := FOnShowEditorToolView;
end;
{$ENDREGION}

{$REGION 'event dispatch methods'}
procedure TEditorEvents.DoChange;
begin
  FOnChange.Invoke(Self);
end;

procedure TEditorEvents.DoModified;
begin
  FOnModified.Invoke(Self);
end;

procedure TEditorEvents.DoHighlighterChange;
begin
  //FHighlighterChangeEvents.CallNotifyEvents(Self);
end;

procedure TEditorEvents.DoActiveViewChange;
begin
  OnActiveViewChange.Invoke(Self);
end;

procedure TEditorEvents.DoAddEditorView(AEditorView: IEditorView);
begin
  OnAddEditorView.Invoke(Self, AEditorView);
end;

procedure TEditorEvents.DoShowToolView(AToolView: IEditorToolView);
begin
  OnShowEditorToolView.Invoke(Self, AToolView);
end;

procedure TEditorEvents.DoHideToolView(AToolView: IEditorToolView);
begin
  OnHideEditorToolView.Invoke(Self, AToolView);
end;

procedure TEditorEvents.DoCaretPositionChange;
begin
  OnCaretPositionChange.Invoke(Self, View.CaretX, View.CaretY);
end;

procedure TEditorEvents.DoActionExecute(AAction: TBasicAction;
  var AHandled: Boolean);
begin
  OnActionExecute.Invoke(Self, AAction, AHandled);
end;

procedure TEditorEvents.DoOpenOtherInstance(const AParams: array of string);
begin
  OnOpenOtherInstance.Invoke(Self, AParams);
end;

procedure TEditorEvents.DoStatusMessage(AText: string);
begin
//  if Assigned(FOnStatusMessage) then
//    FOnStatusMessage(Self, AText);
end;

procedure TEditorEvents.DoOpen(const AName: string);
var
  S : string;
begin
  S  := AName;
  OnOpen.Invoke(Self, S);
end;

{ Called by an editor view to dispatch an event when the editor is about to
  load a file or other content that corresponds to the given AName.
  Note that AName is not necessarily a filename but can eg. be a name that
  corresponds to a database resource to load the text content from. }

procedure TEditorEvents.DoLoad(const AName: string);
var
  S : string;
begin
  S  := AName;
  OnLoad.Invoke(Self, S);
end;

{ Called by the manager instance to dispatch an event when actNew is executed. }

procedure TEditorEvents.DoNew(const AName: string; const AText: string);
var
  S : string;
begin
  S  := AName;
  OnNew.Invoke(Self, S, AText);
end;
{$ENDREGION}

{$REGION 'protected methods'}
{$ENDREGION}
{$ENDREGION}

end.

