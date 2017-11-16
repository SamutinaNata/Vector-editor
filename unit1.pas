unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, Menus, StdCtrls, ActnList, ComCtrls;

type

  { TVectorEditor }

  TVectorEditor = class(TForm)
    ColorDialog1: TColorDialog;
    Panel1 : TPanel;
    bwidth: TLabel;
    MainMenu: TMainMenu;
    bFile: TMenuItem;
    Help: TMenuItem;
    FileExit: TMenuItem;
    FileSave: TMenuItem;
    SaveFile: TSaveDialog;
    bColor: TSpeedButton;
    bBrush: TSpeedButton;
    bLine: TSpeedButton;
    bEllipse: TSpeedButton;
    bRectangle: TSpeedButton;
    Trackwidth: TTrackBar;
    PaintBox: TPaintBox;
    procedure bEllipseClick(Sender: TObject);
    procedure bLineClick(Sender: TObject);
    procedure bRectangleClick(Sender: TObject);
    procedure FileSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FileExitClick(Sender: TObject);
    procedure HelpClick(Sender: TObject);
    procedure PaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaintBoxMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBoxPaint(Sender: TObject);
    procedure bColorClick(Sender: TObject);
    procedure bBrushClick(Sender: TObject);
    procedure TrackwidthChange(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

  type allThings = record
    line : array of TPoint;
    lineLength : integer;
    color : TColor;
    name : string;
    width : integer;
    end;
var
  VectorEditor: TVectorEditor;
  i,j,penState, length: integer;
  drawing : boolean;
  allLine : array of allThings;

implementation

{$R *.lfm}
{ TVectorEditor }

procedure TVectorEditor.PaintBoxMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if drawing = true then
    begin
     case penState of
     1: begin
        allLine[length-1].name := 'brush';
       end;
     2: begin
          allLine[length-1].line[1].x := x;
          allLine[length-1].line[1].y := y;
          PaintBox.Canvas.Line(allLine[length-1].line[0].x,allLine[length-1].line[0].y,allLine[length-1].line[1].x,allLine[length-1].line[1].y);
          allLine[length-1].name := 'line';
        end;
     3: begin
          allLine[length-1].line[1].x := x;
          allLine[length-1].line[1].y := y;
          PaintBox.Canvas.Ellipse(allLine[length-1].line[0].x,allLine[length-1].line[0].y,allLine[length-1].line[1].x,allLine[length-1].line[1].y);
          allLine[length-1].name := 'Ellipse';
        end;
     4: begin
          allLine[length-1].line[1].x := x;
          allLine[length-1].line[1].y := y;
          PaintBox.Canvas.Rectangle(allLine[length-1].line[0].x,allLine[length-1].line[0].y,allLine[length-1].line[1].x,allLine[length-1].line[1].y);
          allLine[length-1].name := 'Rectangle';
        end;
     end;
    drawing:= false;


   end;
end;

procedure TVectorEditor.PaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
   if drawing then
   begin

   if (penState = 1) then
    begin
      allLine[length-1].lineLength := allLine[length-1].lineLength+1;
      setlength(allLine[length-1].line, allLine[length-1].lineLength);
      allLine[length-1].line[allLine[length-1].lineLength-1].x := x;
      allLine[length-1].line[allLine[length-1].lineLength-1].y := y;

      PaintBox.Canvas.LineTo(x,y);

    end;
   end;
end;

procedure TVectorEditor.PaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   PaintBox.Canvas.MoveTo(x,y);
    if ssleft in shift then
    begin
      drawing := true;
      length:=length+1;
      setlength(allLine,length);
      allLine[length-1].lineLength:=0;
      allLine[length-1].color := PaintBox.Canvas.Pen.Color;
      allLine[length-1].width := PaintBox.Canvas.Pen.Width;

    if (penState <> 1) then
     begin
      allLine[length-1].lineLength := 2;
      setlength(allLine[length-1].line, allLine[length-1].lineLength);
      allLine[length-1].line[0].x := x;
      allLine[length-1].line[0].y := y;
     end;

    end;
end;

procedure TVectorEditor.FileSaveClick(Sender: TObject);
  var
  Bitmap: TBitmap;
  Source: TRect;
  Dest: TRect;
begin

  if SaveFile.Execute then
  begin
   Bitmap := TBitmap.Create;
  try
    Bitmap.Width := PaintBox.Width;
    Bitmap.Height:= PaintBox.Height;
    Dest := Rect(0, 0, Bitmap.Width, Bitmap.Height);
    Source := Rect(0, 0, PaintBox.Width, PaintBox.Height);
    Bitmap.Canvas.CopyRect(Dest, PaintBox.Canvas, Source);
    Bitmap.SaveToFile(SaveFile.FileName);
  finally
    Bitmap.Free;
  end;
end;
end;

procedure TVectorEditor.FormCreate(Sender: TObject);
begin
  penState := 1;
  length := 0;
end;

procedure TVectorEditor.FileExitClick(Sender: TObject);
begin
  Close;
end;

procedure TVectorEditor.HelpClick(Sender: TObject);
begin
  Application.MessageBox('Эта программа была сделана Самутиной Натальей студенткой первого курса Прикладной математики и Информатики', 'Справка');
end;


procedure TVectorEditor.PaintBoxPaint(Sender: TObject);
begin
  PaintBox.Canvas.FillRect(0,0,PaintBox.Canvas.width,PaintBox.Canvas.height);

  if (length <> 0) then
  begin
  For i := 0 to length-1 do
  begin

     PaintBox.Canvas.Pen.Color := allLine[i].color;
     PaintBox.Canvas.Pen.Width := allLine[i].width;

     if (allLine[i].name = 'line') then
     PaintBox.Canvas.Line(allLine[i].line[0].x,allLine[i].line[0].y,allLine[i].line[1].x,allLine[i].line[1].y);

     if (allLine[i].name = 'Ellipse') then
     PaintBox.Canvas.Ellipse(allLine[i].line[0].x,allLine[i].line[0].y,allLine[i].line[1].x,allLine[i].line[1].y);

     if (allLine[i].name = 'Rectangle') then
     PaintBox.Canvas.Rectangle(allLine[i].line[0].x,allLine[i].line[0].y,allLine[i].line[1].x,allLine[i].line[1].y);

     if (allLine[i].name = 'brush') then
     PaintBox.Canvas.PolyLine(allLine[i].line[0..allLine[i].lineLength-1]);



  end;

  end;
end;

procedure TVectorEditor.bColorClick(Sender: TObject);
begin
  if ColorDialog1.Execute then
  begin
  PaintBox.Canvas.Pen.Color:= ColorDialog1.Color ;
  end;
end;

procedure TVectorEditor.bBrushClick(Sender: TObject);
begin
  penState := 1;
end;

procedure TVectorEditor.bLineClick(Sender: TObject);
begin
  penState := 2;
end;

procedure TVectorEditor.bRectangleClick(Sender: TObject);
begin
  penState := 4;
end;

procedure TVectorEditor.bEllipseClick(Sender: TObject);
begin
  penState := 3;
end;


procedure TVectorEditor.TrackwidthChange(Sender: TObject);
begin
    PaintBox.Canvas.Pen.Width:= Trackwidth.Position;
end;


end.

