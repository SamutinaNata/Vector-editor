unit UFigures;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons, ComCtrls;


type
  TFigure = class
    FirstPoint, LastPoint, CurrentPoint: TPoint;
    Color: TColor;
    Width: Byte;
    procedure Draw(ACanvas: TCanvas) virtual abstract;
    procedure MouseMove(X, Y: Integer);
   end;

  TEllipse = class(TFigure)
    procedure Draw(ACanvas: TCanvas) override;
  end;

   TPolyLine = class(TFigure)
     Points: array of TPoint;
     CurrentLength: Int64;
     procedure Draw(ACanvas: TCanvas) override;
     constructor Create;
  end;

  TLine = class(TFigure)
       procedure Draw(ACanvas: TCanvas) override;
    end;

  TRectangle = class(TFigure)
     procedure Draw(ACanvas: TCanvas) override;
  end;

implementation

procedure TFigure.MouseMove(X, Y: Integer);
begin
  CurrentPoint := Point(X, Y);
end;
procedure TLine.Draw(ACanvas: TCanvas);
begin
  ACanvas.Pen.Color := Color;
  ACanvas.Pen.Width := Width;
  ACanvas.Line(FirstPoint, LastPoint);
end;

procedure TRectangle.Draw(ACanvas: TCanvas);
var
  Position: TRect;
begin
  //ACanvas.Brush.Color := Color;
  ACanvas.Brush.Style := bsClear;
  ACanvas.Pen.Color := Color;
  ACanvas.Pen.Width := Width;
  Position := Rect(FirstPoint.X, FirstPoint.Y, LastPoint.X, LastPoint.Y);
  ACanvas.Rectangle(Position);
end;

procedure TEllipse.Draw(ACanvas: TCanvas);
var
    Position: TRect;
  begin
    ACanvas.Brush.Style := bsClear;
    ACanvas.Pen.Color := Color;
    ACanvas.Pen.Width := Width;
    Position := Rect(FirstPoint.X, FirstPoint.Y, LastPoint.X, LastPoint.Y);
    ACanvas.Ellipse(Position);
  end;

constructor TPolyLine.Create;
begin
  CurrentLength := 0;
end;

procedure TPolyLine.Draw(ACanvas: TCanvas);
begin
  ACanvas.Pen.Color := Color;
  ACanvas.Pen.Width := Width;
  if(CurrentLength = 0) then
  begin
    SetLength(Points, 1);
    Points[Low(Points)] := FirstPoint;
  end;
  Inc(CurrentLength);
  SetLength(Points, Length(Points) + 1);
  Points[Low(Points) + CurrentLength] := CurrentPoint;
  ACanvas.PolyLine(Points);
end;


end.

