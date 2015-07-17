unit uBingo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Grids, ExtCtrls, StdCtrls, Menus, ugera;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Image1: TImage;
    lbLetraNum: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    sgPainel: TStringGrid;
    Shape1: TShape;
    Shape2: TShape;
    Splitter1: TSplitter;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure sgPainelDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
  private
    { private declarations }

  public
    { public declarations }
    ColorCol, ColorRow, iUlt, iMaxBolas, iMaxCol: integer;
    slBolas: TStringList;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var i, j: Integer;
begin
  iUlt := 0;
  iMaxBolas := 75;
  lbLetraNum.Caption := '';
  if (Application.ParamCount > 0)
    then iMaxBolas := StrtoInt(Application.Params[1]);
  iMaxCol := iMaxBolas div 5;
  slBolas := TStringList.Create;
  sgPainel.ColCount:= iMaxCol + 1;
  Randomize;
  for i:=0 to 4 do
    for j:=1 to iMaxCol do
      sgPainel.Cells[j, i] := Format('%3d', [(i * iMaxCol) + j]);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  slBolas.Free;
end;

procedure TForm1.MenuItem3Click(Sender: TObject);
begin
  slBolas.Free;
  sgPainel.Clean([gzNormal]);
  Self.FormCreate(Sender);
end;

procedure TForm1.MenuItem5Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.MenuItem6Click(Sender: TObject);
begin
    Form2.Show;
end;

procedure TForm1.Button1Click(Sender: TObject);
var novo: LongInt; Pos: Integer;
begin
  if (slBolas.Count >= iMaxBolas) then begin
    ShowMessage('Não há mais bolas a sortear');
    exit;
  end;
  repeat
    novo := Random(iMaxBolas) + 1;
  until (slBolas.IndexOf( Format('%.3d', [novo]) ) < 0) ;
  slBolas.Add(Format('%.3d', [novo]) );
  pos :=  ((novo - 1)  div  iMaxCol) + 1;
  lbLetraNum.Caption:= Copy('BINGO', pos, 1) + ' ' + InttoStr(novo);
  ColorRow := pos - 1;
  ColorCol := novo - (iMaxCol * (pos - 1));
  sgPainel.Invalidate;
  Form2.BitBtn4Click(Sender);
end;

procedure TForm1.sgPainelDrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
var S: string; i: Integer;
begin
// iMaxCol := iMaxBolas div 5; // 18
if (ACol = 0) then begin
  sgPainel.Canvas.Font.Color:=clBlack;
  sgPainel.Canvas.Font.Bold:=true;
  sgPainel.Canvas.FillRect(aRect);
  S := sgPainel.Cells[ACol, ARow];
  sgPainel.Canvas.TextOut(aRect.Left + 2, aRect.Top + 1, S); end
else begin
  for i:=0 to slBolas.Count - 1 do begin
    ColorRow := (StrtoInt(slBolas[i]) - 1)  div  iMaxCol ;
    ColorCol := StrtoInt(slBolas[i]) - (iMaxCol * ColorRow);
    if (ACol = ColorCol) and (ARow = ColorRow) then begin
      sgPainel.Canvas.Brush.Color := clYellow;
      sgPainel.Canvas.Font.Color:=clBlack;
      sgPainel.Canvas.Font.Bold:=true;
      sgPainel.Canvas.FillRect(aRect);
      S := sgPainel.Cells[ACol, ARow];
      sgPainel.Canvas.TextOut(aRect.Left + 2, aRect.Top + 1, S);
  //    sgPainel.Canvas.FrameRect(aRect);
    end;
  end;
end;
end;

end.

