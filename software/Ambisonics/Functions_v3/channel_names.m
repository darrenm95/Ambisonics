function names = channel_names(sphericalHarmonic, ...
    letter_naming_limit, name_format)
%channel_names names channels using letters up to 3rd order ambisonics,
%wherein after, the acn numerical naming format is adopted
   
    if ~exist('letter_limit', 'var') || isempty(letter_naming_limit)
        letter_naming_limit = 3;
    end
    
    if letter_naming_limit > 3
        warning('No letter names above 3, using acn number convention');
        letter_naming_limit = 3;
    end
    
    if ~exist('name_format', 'var') || isempty(name_format)
        name_format = 'acn_%d';
    end
    
    sphericalHarmonic.l = sphericalHarmonic.degree;
    sphericalHarmonic.m = sphericalHarmonic.order;
    
    fumaConvention_channel_names = {...
        'W',...
        'Y', 'Z', 'X', ...
        'V', 'T', 'R', 'S', 'U', ...
        'Q', 'O', 'M', 'K', 'L', 'N', 'P'};
    
    acn = sphericalHarmonic.l.^2 + sphericalHarmonic.l + ...
        sphericalHarmonic.m;
    names = cell(size(acn));
    
    names(sphericalHarmonic.l<=letter_naming_limit) = ...
        fumaConvention_channel_names(acn(sphericalHarmonic.l <= ...
        letter_naming_limit)+1);
    
    for i = acn(sphericalHarmonic.l > letter_naming_limit)
        names{acn == i} = sprintf( name_format, ...
            acn(acn == i));
    end
    
end
