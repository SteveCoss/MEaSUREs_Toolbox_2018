function [ hb, hb1 ] = rating(xmlfile, dc,Toggle)
% convert discharges dc to base heights ht
% using the rating curve of xmlfile
fid = fopen(fullfile(Toggle.USGSlistdir,['rating/r', strrep(xmlfile, '.xml', '.txt')]), 'r');
mm = 100000;
ht = zeros(50000, 1);
dd = zeros(50000, 1); qq = zeros(50000, 1);
rec = fgetl(fid); nl = 1;
while ischar(rec)
    rec = fgetl(fid); nl = nl +1;
    if length(rec) <5
        if uint8(rec(1)) ~=0, fprintf('Not a NULL terminator.\n'), end
        if mm >nl
            hb = []; hb1 = []; return
        else
            break
        end
    end
    % first data line starts w/ keyword INDEP.
    if strcmp(rec(1:5),'INDEP'), mm = nl +1; end
    if nl >mm
        ii = nl -mm;
        buf = sscanf(rec, '%f', 3);
        ht(ii) = buf(1);
        dd(ii) = buf(2); qq(ii) = buf(3);
    end
end
fclose(fid);
ht = ht(1:ii); dd = dd(1:ii); qq = qq(1:ii);
if any(diff(ht) <0), error('rating: Negative height changes.'), end
if any(diff(qq) <0), error('rating: Negative discharge changes.'), end
if ~any(diff(qq) ==0)
    hb1= interp1(qq, ht, dc, 'linear');
    hb = interp1(qq, dd, dc, 'previous');
else
    fprintf('rating: Zero discharge rates in lookup table removed.\n')
    [uu, iq, ~] = unique(qq);
    hb1= interp1(uu, ht(iq), dc, 'linear');
    hb = interp1(uu, dd(iq), dc, 'previous');
end
hb(isnan(hb)) = 0;
hb = hb1 +hb;
end
