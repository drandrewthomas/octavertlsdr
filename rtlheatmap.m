% RTLHEATMAP.M: An Octave script to read a file produced by
% rtl_power and plot it as a heatmap saved in an image file.
% For use with rtl_power data over a time period rather than with
% a single-shot reading. It's set up to work from the commandline
% in a headless environment, but is easily changed if you just
% want GnuPlot to open a GUI plot window instead.
% Copyright 2015-2016 Andrew Thomas.
% Released under GPL2 (see https://github.com/geocomputing/octavertlsdr).

graphics_toolkit("gnuplot");
arglist=argv();
file=arglist{1};
% Prepare by creating some useful variables
first=1;
firstdate=0;
lastdate=0;
numf=0;
numd=0;
ind=1;
mindate=999999999999;
maxdate=-999999999999;
mindb=999999999999;
maxdb=-999999999999;
minf=999999999999;
maxf=-999999999999;
% First we determine the size of matrix we'll need
fp=fopen(file,'rt');
while ~ feof(fp)
  line=strtrim(fgetl(fp));
  line=regexprep(line,' ','');
  bits=strsplit(line,',');
  if length(bits)>6
    dt=datenum(sprintf('%s %s',bits{1},bits{2}),'yyyy-mm-dd HH:MM:SS');
    utc=(dt-datenum(1970,1,1))*(24*60*60);
    if utc<mindate
      mindate=utc;
    end
    if utc>maxdate
      maxdate=utc;
    end
    if first==1
      firstdate=utc;
      first=0;
    end
    if utc~=lastdate
      lastdate=utc;
      numd=numd+1;
    end
    if utc==firstdate
      numf=numf+length(bits)-6;
    end
  end
end
fclose(fp);
% Then we create a matrix for the data to go into
data=zeros(numd,numf);
% Now we read the data from the file into the matrix
dind=0;
find=1;
lastdate=0;
fp=fopen(file,'rt');
while ~ feof(fp)
  line=strtrim(fgetl(fp));
  line=regexprep(line,' ','');
  bits=strsplit(line,',');
  if length(bits)>6
    dt=datenum(sprintf('%s %s',bits{1},bits{2}),'yyyy-mm-dd HH:MM:SS');
    utc=(dt-datenum(1970,1,1))*(24*60*60);
    if utc~=lastdate
      lastdate=utc;
      dind=dind+1;
      find=1;
    end
    if str2num(bits{4})>maxf
      maxf=str2num(bits{4});
    end
    if str2num(bits{3})<minf
      minf=str2num(bits{3});
    end
    for c=1:1:length(bits)-6
      data(dind,find)=str2num(bits{c+6});
      find=find+1;
      if str2num(bits{c+6})>maxdb
        maxdb=str2num(bits{c+6});
      end
      if str2num(bits{c+6})<mindb
        mindb=str2num(bits{c+6});
      end
    end
  end
end
minf=minf/1000000;
maxf=maxf/1000000;
fclose(fp);
% Now we plot a pretty picture of the data
h=figure(1);
x=linspace(minf,maxf,numf);
y=linspace(0,(maxdate-mindate)/3600,numd);
imagesc(x,y,data);
xlabel ('Frequency (MHz)');
ylabel ('Time (hours)');
print(h,'-dpng','-color','test.png');

