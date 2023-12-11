program KHS_Kelompok_HTML;
uses
  crt, sysutils;
const
  nilaiA = 4.0;
  nilaiBplus = 3.5;
  nilaiB = 3.0;
  nilaiCplus = 2.5;
  nilaiC = 2.0;
  nilaiD = 1.0;
  nilaiE = 0.0;
type
  recordMatkul = record
    nama: string;
    sks: byte;
  end;

  recordMahasiswa = record
    nama, nim: string;
    nilaiString: array of string;
    nilaiReal: array of real;
    totalNilai, totalSKS, ip: real;
  end;

function convertToReal(grade: string): real;
begin
  case (grade) of
    'A': convertToReal := nilaiA;
    'B+': convertToReal := nilaiBplus;
    'B': convertToReal := nilaiB;
    'C+': convertToReal := nilaiCplus;
    'C': convertToReal := nilaiC;
    'D': convertToReal := nilaiD;
    'E': convertToReal := nilaiE;
    else
      begin
        writeln('Error: Nilai tidak valid - ', grade, '. Nilai harus dalam huruf KAPITAL(A,B+,B,C+,C,D,E).');
        convertToReal := 0.0;
      end;
  end;
end;

procedure createKHSFile;
var
  matkul: array of recordMatkul;
  mahasiswa: recordMahasiswa;
  outFile: TextFile;
  i, n: integer;
  namaFile: string;

begin
  clrscr;

  Write('Banyak Matkul : ');
  ReadLn(n);
  SetLength(matkul, n);

  for i := 0 to n - 1 do
  begin
    clrscr;
    writeln('Matkul [', i + 1, ']');
    writeln('=======================');
    Write('Nama Matkul : ');
    ReadLn(matkul[i].nama);

    repeat
      Write('SKS         : ');
      ReadLn(matkul[i].sks);
      if (matkul[i].sks <= 0) then
        writeln('Error: SKS Tidak Boleh negatif/nol. Mohon Masukkan Angka Yang Valid.');
    until matkul[i].sks > 0;
  end;

  clrscr;
  writeln('Mahasiswa');
  writeln('=====================');
  writeln;

  Write('Nama : ');
  Readln(mahasiswa.nama);

  repeat 
    Write('NIM  : ');
    ReadLn(mahasiswa.nim);
    if (Length(mahasiswa.nim) <> 9) then
      writeln('Error: Panjang NIM harus 9 digit. Mohon masukkan NIM yang valid.');
  until Length(mahasiswa.nim) = 9;

  SetLength(mahasiswa.nilaiString, n); //untuk mengatur panjang dari array string atau string dinamis mahasiswa.nilaiString menjadi suatu nilai tertentu n
  SetLength(mahasiswa.nilaiReal, n); //untuk mengatur panjang dari array string atau string dinamis mahasiswa.nilaiReal menjadi suatu nilai tertentu n

  for i := 0 to n - 1 do
  begin
    repeat
      Write('Nilai ', matkul[i].nama, ' : ');
      ReadLn(mahasiswa.nilaiString[i]);
      if (convertToReal(mahasiswa.nilaiString[i]) < 0.0) or (convertToReal(mahasiswa.nilaiString[i]) > 4.0) then
        Writeln('Error: Nilai Tidak Valid. Masukkan nilai antara 0.0(E) dan 4.0(A)!');
    until (convertToReal(mahasiswa.nilaiString[i]) >= 0.0) and (convertToReal(mahasiswa.nilaiString[i]) <= 4.0);
  end;

  mahasiswa.totalNilai := 0;
  mahasiswa.totalSKS := 0;

  for i := 0 to n - 1 do
  begin
    mahasiswa.nilaiReal[i] := convertToReal(mahasiswa.nilaiString[i]);
    mahasiswa.totalNilai := mahasiswa.totalNilai + (mahasiswa.nilaiReal[i] * matkul[i].sks);
    mahasiswa.totalSKS := mahasiswa.totalSKS + matkul[i].sks;
  end;

  mahasiswa.ip := 0;
  if (mahasiswa.totalSKS <> 0) then
    mahasiswa.ip := mahasiswa.totalNilai / mahasiswa.totalSKS;

  namaFile := Format('KHS_%s_%s.txt', [mahasiswa.nim, mahasiswa.nama]);

  Assign(outFile, namaFile);
  rewrite(outFile);

  writeln(outFile, 'Kartu Hasil Studi');
  writeln(outFile, '=================');
  writeln(outFile, '                 ');
  writeln(outFile, 'Nama      : ', mahasiswa.nama);
  writeln(outFile, 'NIM       : ', mahasiswa.nim);
  writeln(outFile, '                 ');
  writeln(outFile, '|=============================================|');
  writeln(outFile, '| No  |Matkul                           |Nilai|');
  writeln(outFile, '|=============================================|');

  for i := 0 to n - 1 do
    writeln(outFile, Format('| %-2d. |%-32s |%-5s|', [i + 1, matkul[i].nama, mahasiswa.nilaiString[i]]));

  writeln(outFile, '|=============================================|');
  writeln(outFile, '                 ');
  writeln(outFile, 'Total SKS   : ', mahasiswa.totalSKS:0:0);
  writeln(outFile, 'IP Semester : ', mahasiswa.ip:0:2);

  Close(outFile);
  writeln('KHS telah berhasil dibuat. File disimpan dengan nama: ', namaFile);
end;
begin
  createKHSFile;
end.