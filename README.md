# density_from_localization
This code uses the localization result and rectification to generate density grid.

**runme_update_rectification.m** adds a rotation to the rectification such that the grid lines are alligned to the image horizontally.

**runme_mark_world.m** is used to mark a world measurement in the image which is used to caliberate the camera.

**runme_density.m** projects the head locations in a rectified space and count the number of people in each cell of a uniform grid. It also projects this information on the image. 
