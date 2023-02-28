function [sphereROI, vox_num] = xlz_constructROI(mat_coor, space, radius)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    x = mat_coor(1);
    y = mat_coor(2);
    z = mat_coor(3);
    sphereROI = space; 
    if radius == 0
        sphereROI(x,y,z) = 1;
        vox_num = sum(sum(sum(sphereROI)));
    else
        space(x,y,z) = 1;
        for dx = -radius:1:radius
            for dy = -radius:1:radius
                for dz = -radius:1:radius
                    if sqrt(dx ^ 2 + dy ^ 2 + dz ^ 2) <= radius
                        space(x+dx,y+dy,z+dz) = 1;
                    end
                end
            end
        end
        sphereROI = space;
        vox_num = sum(sum(sum(sphereROI)));
    end
end

