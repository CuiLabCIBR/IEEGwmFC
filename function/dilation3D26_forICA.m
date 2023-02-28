function cimage = dilation3D26_forICA(bimage)
% bimage is a binary input 3D image

cimage = zeros(size(bimage));

for i=-1:1
    for j=-1:1
        for k=-1:1
            cimage = cimage + circshift(bimage, [i, j, k]);
        end
    end
end


end