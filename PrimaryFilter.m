function  [VS] = PrimaryFilter(VS,S,stations,FilterData,Toggle,rivername)
for i=stations,
    if ~isempty(FilterData)
    [VS(i).AltDat] = HeightFilter2(VS(i).AltDat,S(i),FilterData(i),Toggle.IceData,Toggle.DoIce,VS(i).ID);
    VS(i).AltDat = CalcAvgHeights2(FilterData(i).AbsHeight,VS(i).AltDat,VS(i).ID,Toggle.IceData);
    VS(i).AltDat.AbsHeight=FilterData(i).AbsHeight;
    if Toggle.tide && VS(i).AltDat.Write
        [VS(i)] = tidecheck2(VS(i),rivername,Toggle.Tname,Toggle.Tdist);
    end
    else
        VS=[];
    end
end
