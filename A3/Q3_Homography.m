function H = Q3_Homography(points_1,points_2)
%finding a 3x3 homography matrix between sets of matching points

n = size(points_1,1);%number of matching points

A = zeros(2*n,9);%number of rows in the homography matrix is 2 times matching points

%according to homography matrix in page 3 of lecture 20 notes, we fill the
%matrix elements

A(1:2:2*n,1:2) = points_1;
A(1:2:2*n,3) = 1;
A(2:2:2*n,4:5) = points_1;
A(2:2:2*n,6) = 1;

x1 = points_1(:,1);
y1 = points_1(:,2);
x2 = points_2(:,1);
y2 = points_2(:,2);

A(1:2:2*n,7) = -x2.*x1;
A(2:2:2*n,7) = -y2.*x1;
A(1:2:2*n,8) = -x2.*y1;
A(2:2:2*n,8) = -y2.*y1;
A(1:2:2*n,9) = -x2;
A(2:2:2*n,9) = -y2;

%returning the eigenvector with the smallest eigen value
[V,~] = eig(A'*A);
H = reshape(V(:,1),[3,3])';%reshaping the column matrix into 3x3 matrix
H = H/H(end); % to make H(3,3) = 1 (Euclidean normalization)

end