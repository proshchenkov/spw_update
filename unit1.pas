unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls,
  ExtCtrls, ComCtrls, Buttons, IdHTTP, IdComponent, LCLIntf;

type

  { TForm1 }

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    IdHTTP1: TIdHTTP;
    MainMenu1: TMainMenu;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    Panel1: TPanel;
    ProgressBar1: TProgressBar;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure IdHTTP1Work(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCount: int64);
    procedure IdHTTP1WorkBegin(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCountMax: int64);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  a: int64;
  n1, n2, n3, n4: integer;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.MenuItem1Click(Sender: TObject);
begin
  if MenuItem2.Caption = 'Русский' then
    OpenURL('http://voloshinov.ru/simplex/eindex.htm')
  else
    OpenURL('http://voloshinov.ru/simplex/index.htm');
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
var
  Stream: TMemoryStream;
begin
  try
    try
      Stream := TMemoryStream.Create;
      IdHTTP1.Get('http://voloshinov.ru/simplex/spw.exe', Stream);
      a := IdHTTP1.Response.ContentLength;
      RenameFile('spw.exe', 'spw.old');
      Stream.SaveToFile('spw.exe');
    finally
      Stream.Free;
      IdHTTP1.Disconnect;
    end;
  except
    RenameFile('spw.old', 'spw.exe');
    if MenuItem2.Caption = 'Русский' then
      Memo1.Lines.Add('Unsuccessful attempt to receive a file from the server')
    else
      Memo1.Lines.Add(
        'Неудачная попытка приема файла с сервера');
  end;
  DeleteFile('spw.old');
  if MenuItem2.Caption = 'Русский' then
    Memo1.Lines.Add('Update completed')
  else
    Memo1.Lines.Add('Обновление завершено');
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  fil: textfile;
begin
  try
    assignfile(fil, 'spw.ver');
    reset(fil);
    readln(fil, n1);
    readln(fil, n2);
    readln(fil, n3);
    readln(fil, n4);
    Memo1.Lines.Add('The latest available version of Simplex ' +
      IntToStr(n1) + '.' + IntToStr(n2) + '.' + IntToStr(n3) + '.' + IntToStr(n4));
    Memo1.Lines.Add('Последняя доступная версия Симплекс  '
      + IntToStr(n1) + '.' + IntToStr(n2) + '.' + IntToStr(n3) + '.' + IntToStr(n4));
    closefile(fil);
  except
  end;
end;

procedure TForm1.IdHTTP1Work(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: int64);
begin
  ProgressBar1.Position := ProgressBar1.Position + AWorkCount;
end;

procedure TForm1.IdHTTP1WorkBegin(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCountMax: int64);
begin
  ProgressBar1.Max := AWorkCountMax;
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  if MenuItem2.Caption = 'Русский' then
  begin
    Form1.Caption := 'Обновление Симплекс';
    BitBtn1.Caption := 'Обновить';
    BitBtn2.Caption := 'Отмена';
    MenuItem1.Caption := 'Посетить сайт';
    MenuItem2.Caption := 'English';
  end
  else
  begin
    Form1.Caption := 'Simplex Update';
    BitBtn1.Caption := 'Update';
    BitBtn2.Caption := 'Cancel';
    MenuItem1.Caption := 'Visit site';
    MenuItem2.Caption := 'Русский';
  end;
end;

end.


