unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, Buttons, Spin, Menus, StdCtrls, UFigures;

type

  { TForm1 }

  TForm1 = class(TForm)
    ColorDialog: TColorDialog;
    Label1: TLabel;
    MainMenu: TMainMenu;
    MenuItem: TMainMenu;
    Help: TMenuItem;
    FileIteam: TMenuItem;
    SaveDialog: TSaveDialog;
    SaveFile: TMenuItem;
    CloseAll: TMenuItem;
    PaintBox: TPaintBox;
    Panel1: TPanel;
    bcolor: TSpeedButton;
    bBrush: TSpeedButton;
    bLine: TSpeedButton;
    bEllipse: TSpeedButton;
    bRectangle: TSpeedButton;
    SpinEdit: TSpinEdit;
    procedure FormCreate(Sender: TObject);
    procedure CloseAllClick(Sender: TObject);
    procedure HelpClick(Sender: TObject);
    procedure SaveFileClick(Sender: TObject);
    procedure PaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaintBoxMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBoxPaint(Sender: TObject);
    procedure bcolorClick(Sender: TObject);
    procedure bBrushClick(Sender: TObject);
    procedure SpinEditChange(Sender: TObject);


  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  Figures: array of TFigure;
  CurrentFigure: TFigure;
  FigureColor: TColor;
  isDrawing, isClicked: Boolean;
  ToolNum, FigureWidth: Byte;


implementation
{$R *.lfm}

{ TForm1 }


procedure TForm1.FormCreate(Sender: TObject);
begin
   isClicked:= true;
   ToolNum:=0;
   Form1.DoubleBuffered:=true;
end;

procedure TForm1.CloseAllClick(Sender: TObject);
begin
    Close;
end;

procedure TForm1.HelpClick(Sender: TObject);
begin
    ShowMessage('Редактор создан Самутиой Натальей');
end;

procedure TForm1.SaveFileClick(Sender: TObject);
var
    Bitmap: TBitmap;
    Source: TRect;
    Dest: TRect;
begin

  if (SaveDialog.Execute) then
  begin
   Bitmap := TBitmap.Create;
  try
    Bitmap.Width := PaintBox.Width;
    Bitmap.Height:= PaintBox.Height;
    Dest := Rect(0, 0, Bitmap.Width, Bitmap.Height);
    Source := Rect(0, 0, PaintBox.Width, PaintBox.Height);
    Bitmap.Canvas.CopyRect(Dest, PaintBox.Canvas, Source);
    Bitmap.SaveToFile(SaveDialog.FileName);
  finally
    Bitmap.Free;
  end;

  end;
end;

procedure TForm1.PaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

    if (isClicked) then
     begin
      isDrawing := True;

     case ToolNum of
      0: CurrentFigure := TPolyLine.Create;
      1: CurrentFigure := TRectangle.Create;
      2: CurrentFigure := TEllipse.Create;
      3: CurrentFigure := TLine.Create;
     end;
      CurrentFigure.Color := FigureColor;
      CurrentFigure.Width := FigureWidth;
      CurrentFigure.FirstPoint := Point(X, Y);
    end;

end;



procedure TForm1.PaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
   if(isDrawing) then
    begin
      PaintBox.Refresh;
      CurrentFigure.MouseMove(X, Y);
      CurrentFigure.LastPoint := Point(X, Y);
      CurrentFigure.Draw(PaintBox.Canvas);
    end;
end;

procedure TForm1.PaintBoxMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);

begin
   if(isDrawing) then
  begin
    isDrawing := False;
    CurrentFigure.LastPoint := Point(X, Y);
    CurrentFigure.MouseMove(X, Y);
    CurrentFigure.Draw(PaintBox.Canvas);
    SetLength(Figures, length(Figures) + 1);
    Figures[High(Figures)] := CurrentFigure;
  end;

end;

procedure TForm1.PaintBoxPaint(Sender: TObject);
 var F: TFigure;
begin
    PaintBox.Canvas.Pen.Color := ClWhite;
    PaintBox.Canvas.FillRect(0, 0, PaintBox.Width, PaintBox.Height);
    for F in Figures do F.Draw(PaintBox.Canvas);
end;

procedure TForm1.bcolorClick(Sender: TObject);
begin
   if((ColorDialog.Execute) and (isClicked)) then
   FigureColor := ColorDialog.Color;
end;

procedure TForm1.bBrushClick(Sender: TObject);
begin
   isClicked := True;
   ToolNum := (Sender as TSpeedButton).Tag;
end;

procedure TForm1.SpinEditChange(Sender: TObject);
begin
  if(isClicked) then FigureWidth := SpinEdit.Value;
end;
end.

