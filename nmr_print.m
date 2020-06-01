% NMR Print, 2019
function [] = nmr_print (nmrDir,rF,ol,ow,oh,thick,o,figaxes)
%% Initial Setup
tic  %Start Timer.

%Load data from nmrDir
fileID = fopen(nmrDir,'r');
datastrip = cell2mat( textscan(fileID, '%f%f', 'CommentStyle', '#', 'CollectOutput', true) );
datastrip(:,2) = [];
Zraw = reshape(datastrip,[2048,2048]).';

%Split data into grid based on rF value.
rowId = ceil( (1 : size(Zraw, 1)) / rF );
colId = ceil( (1 : size(Zraw, 2)) / rF );
[colID, rowID] = meshgrid( colId, rowId );
gridID = colID + (rowID - 1) * max(colId);

%Average each grid section to smooth data.
meanList = accumarray( gridID(:), Zraw(:), [], @mean );
Zproc = meanList(:);
Zproc = Zproc';
cutSize = (size(Zraw,1)) / rF;
Z = vec2mat(Zproc,cutSize);

%% Setup Axes
xRange = size(Z,1); %Detect x range from z data.
yRange = size(Z,2); %Detect y range from z data.

% Create x & y axis matrix based on detected values.
X = repmat(1:xRange, 1, 1);
Y = repmat(1:yRange, 1, 1);
Y = Y';

% Check data is ok
if (numel(X)*numel(Y)~= numel(Z))
    fprintf('There appears to be an error in matrix values. \nHas your data been processed by the python script yet?\n\n');
    return; %Abort if not ok.
end

%% Plot The Surface
hold(figaxes,'on');
set(figaxes,'CLim',[0 200000]);

surf(figaxes,X,Y,Z,'EdgeColor','none');
view(figaxes,[0 90]);
xlim(figaxes,[0 max(X)]);
ylim(figaxes,[0 max(Y)]);

%% Export MatLab Editable Figure
%fignew = figure('Visible','off'); % Invisible figure.
%newAxes = copyobj(figaxes,fignew); % Copy the appropriate axes.
%set(newAxes,'Position',get(groot,'DefaultAxesPosition')); % The original position is copied too, so adjust it.
%set(fignew,'CreateFcn','set(gcbf,''Visible'',''on'')'); % Make it visible upon loading.
%savefig(fignew,'NMR-FIGURE.fig'); % Export figure.
%delete(fignew); % Once saved, delete the figure in memory.

%% Scale The Model To Desired Size.
xf=max(X(:))-min(X(:));
yf=max(Y(:))-min(Y(:));
zf=max(Z(:))-min(Z(:));

X=X*ol/xf;
Y=Y*ow/yf;
Z=Z*oh/zf;

%% Write STL File
t = thick;
s=surf2solid(X,Y,Z,'thickness',-t);
[folder, baseFileName, extension] = fileparts(nmrDir);
newName = sprintf('%s.stl', baseFileName);
newName = fullfile(folder, newName);
stlwrite(newName,s);

%% Open STL File If Requested
isWin = ispc; %Returns 1 if running on Microsoft Windows.
if (o==1)
    if (isWin==1)
        winopen nmr_model.stl
    else
        macopen nmr_model.stl
    end
end

if (o~=1)
    return;
end

toc
end

%% Functions

function macopen(file)
% Opens a file or directory on a mac
% Author: Manu Raghavan, 2009

if(nargin==0 || nargin>1 || ~ischar(file))
    error('Please specify at one input argument, file or directory, to be opened');
end

if(~ismac)
    if(ispc)
        error('macopen does not work on Windows, use winopen instead');
    else
        error('macopen does not work on other operating systems');
    end
end

system(['open ',file]);
end

function stlwrite(filename, varargin)
% Writes stl file from data
% Author: Sven Holcombe, 2011

% Check valid filename path
path = fileparts(filename);
if ~isempty(path) && ~exist(path,'dir')
    error('Directory "%s" does not exist.',path);
end

% Get faces, vertices, and user-defined options for writing
[faces, vertices, options] = parseInputs(varargin{:});
asciiMode = strcmp( options.mode ,'ascii');

% Create the facets
facets = single(vertices');
facets = reshape(facets(:,faces'), 3, 3, []);

% Compute their normals
V1 = squeeze(facets(:,2,:) - facets(:,1,:));
V2 = squeeze(facets(:,3,:) - facets(:,1,:));
normals = V1([2 3 1],:) .* V2([3 1 2],:) - V2([2 3 1],:) .* V1([3 1 2],:);
clear V1 V2
normals = bsxfun(@times, normals, 1 ./ sqrt(sum(normals .* normals, 1)));
facets = cat(2, reshape(normals, 3, 1, []), facets);
clear normals

% Open the file for writing
permissions = {'w','wb+'};
fid = fopen(filename, permissions{asciiMode+1});
if (fid == -1)
    error('stlwrite:cannotWriteFile', 'Unable to write to %s', filename);
end

% Write the file contents
if asciiMode
    % Write HEADER
    fprintf(fid,'solid %s\r\n',options.title);
    % Write DATA
    fprintf(fid,[...
        'facet normal %.7E %.7E %.7E\r\n' ...
        'outer loop\r\n' ...
        'vertex %.7E %.7E %.7E\r\n' ...
        'vertex %.7E %.7E %.7E\r\n' ...
        'vertex %.7E %.7E %.7E\r\n' ...
        'endloop\r\n' ...
        'endfacet\r\n'], facets);
    % Write FOOTER
    fprintf(fid,'endsolid %s\r\n',options.title);
    
else % BINARY
    % Write HEADER
    fprintf(fid, '%-80s', options.title);             % Title
    fwrite(fid, size(facets, 3), 'uint32');           % Number of facets
    % Write DATA
    % Add one uint16(0) to the end of each facet using a typecasting trick
    facets = reshape(typecast(facets(:), 'uint16'), 12*2, []);
    % Set the last bit to 0 (default) or supplied RGB
    facets(end+1,:) = options.facecolor;
    fwrite(fid, facets, 'uint16');
end

% Close the file
fclose(fid);
fprintf('Wrote %d facets\n',size(facets, 3));

%% Input handling subfunctions
function [faces, vertices, options] = parseInputs(varargin)
% Determine input type
if isstruct(varargin{1}) % stlwrite('file', FVstruct, ...)
    if ~all(isfield(varargin{1},{'vertices','faces'}))
        error( 'Variable p must be a faces/vertices structure' );
    end
    faces = varargin{1}.faces;
    vertices = varargin{1}.vertices;
    options = parseOptions(varargin{2:end});
    
elseif isnumeric(varargin{1})
    firstNumInput = cellfun(@isnumeric,varargin);
    firstNumInput(find(~firstNumInput,1):end) = 0; % Only consider numerical input PRIOR to the first non-numeric
    numericInputCnt = nnz(firstNumInput);
    
    options = parseOptions(varargin{numericInputCnt+1:end});
    switch numericInputCnt
        case 3 % stlwrite('file', X, Y, Z, ...)
            % Extract the matrix Z
            Z = varargin{3};
            
            % Convert scalar XY to vectors
            ZsizeXY = fliplr(size(Z));
            for i = 1:2
                if isscalar(varargin{i})
                    varargin{i} = (0:ZsizeXY(i)-1) * varargin{i};
                end                    
            end
            
            % Extract X and Y
            if isequal(size(Z), size(varargin{1}), size(varargin{2}))
                % X,Y,Z were all provided as matrices
                [X,Y] = varargin{1:2};
            elseif numel(varargin{1})==ZsizeXY(1) && numel(varargin{2})==ZsizeXY(2)
                % Convert vector XY to meshgrid
                [X,Y] = meshgrid(varargin{1}, varargin{2});
            else
                error('stlwrite:badinput', 'Unable to resolve X and Y variables');
            end
            
            % Convert to faces/vertices
            if strcmp(options.triangulation,'delaunay')
                faces = delaunay(X,Y);
                vertices = [X(:) Y(:) Z(:)];
            else
                if ~exist('mesh2tri','file')
                    error('stlwrite:missing', '"mesh2tri" is required to convert X,Y,Z matrices to STL. It can be downloaded from:\n%s\n',...
                        'http://www.mathworks.com/matlabcentral/fileexchange/28327')
                end
                [faces, vertices] = mesh2tri(X, Y, Z, options.triangulation);
            end
            
        case 2 % stlwrite('file', FACES, VERTICES, ...)
            faces = varargin{1};
            vertices = varargin{2};
            
        otherwise
            error('stlwrite:badinput', 'Unable to resolve input types.');
    end
end

if ~isempty(options.facecolor) % Handle colour preparation
    facecolor = uint16(options.facecolor);
    %Set the Valid Color bit (bit 15)
    c0 = bitshift(ones(size(faces,1),1,'uint16'),15);
    %Red color (10:15), Blue color (5:9), Green color (0:4)
    c0 = bitor(bitshift(bitand(2^6-1, facecolor(:,1)),10),c0);
    c0 = bitor(bitshift(bitand(2^11-1, facecolor(:,2)),5),c0);
    c0 = bitor(bitand(2^6-1, facecolor(:,3)),c0);
    options.facecolor = c0;    
else
    options.facecolor = 0;
end

function options = parseOptions(varargin)
IP = inputParser;
IP.addParamValue('mode', 'binary', @ischar) %#ok<*NVREPL>
IP.addParamValue('title', sprintf('Created by stlwrite.m %s',datestr(now)), @ischar);
IP.addParamValue('triangulation', 'delaunay', @ischar);
IP.addParamValue('facecolor',[], @isnumeric)
IP.parse(varargin{:});
options = IP.Results;

function [F,V]=mesh2tri(X,Y,Z,tri_type)
% Included here for convenience. Many thanks to Kevin Mattheus Moerman

[J,I]=meshgrid(1:1:size(X,2)-1,1:1:size(X,1)-1);

switch tri_type
    case 'f'%Forward slash
        TRI_I=[I(:),I(:)+1,I(:)+1;  I(:),I(:),I(:)+1];
        TRI_J=[J(:),J(:)+1,J(:);   J(:),J(:)+1,J(:)+1];
        F = sub2ind(size(X),TRI_I,TRI_J);
    case 'b'%Back slash
        TRI_I=[I(:),I(:)+1,I(:);  I(:)+1,I(:)+1,I(:)];
        TRI_J=[J(:)+1,J(:),J(:);   J(:)+1,J(:),J(:)+1];
        F = sub2ind(size(X),TRI_I,TRI_J);
    case 'x'%Cross
        TRI_I=[I(:)+1,I(:);  I(:)+1,I(:)+1;  I(:),I(:)+1;    I(:),I(:)];
        TRI_J=[J(:),J(:);    J(:)+1,J(:);    J(:)+1,J(:)+1;  J(:),J(:)+1];
        IND=((numel(X)+1):numel(X)+prod(size(X)-1))';
        F = sub2ind(size(X),TRI_I,TRI_J);
        F(:,3)=repmat(IND,[4,1]);
        Fe_I=[I(:),I(:)+1,I(:)+1,I(:)]; Fe_J=[J(:),J(:),J(:)+1,J(:)+1];
        Fe = sub2ind(size(X),Fe_I,Fe_J);
        Xe=mean(X(Fe),2); Ye=mean(Y(Fe),2);  Ze=mean(Z(Fe),2);
        X=[X(:);Xe(:)]; Y=[Y(:);Ye(:)]; Z=[Z(:);Ze(:)];
end

V=[X(:),Y(:),Z(:)];
end
end
end
end

function varargout = surf2solid(varargin)
%   Original idea adapted from Paul Kassebaum's blog post
%   http://blogs.mathworks.com/community/2013/06/20/paul-prints-the-l-shaped-membrane/
%   Many thanks to Paul for his further input and improvements.
%   Author: Sven Holcombe, 07-20-2013

% Get faces, vertices, and user-defined options for writing
[F, V, options] = parseInputs(varargin{:});

% Get the latest triangulation class. 2013a brought in "triangulation" with
% some nice options. Earlier versions must use "TriRep".
if exist('triangulation','class')
    T = triangulation(F,V);
    options.oldVersion = false;
else
    T = TriRep(F,V); %#ok
    options.oldVersion = true;
end
% Extract boundary edges from input surface. These will connect to walls.
boundEdges = T.freeBoundary;
boundVerts = boundEdges([1:end 1],1);

% Define "other" faces opposite to input faces. These will either sit at
% given Z-elevations, or they will be offset from input faces by thickness.
if ~isempty(options.elevation)  % ELEVATION was specified
    % If scalar elevation was given, it will be assigned here. If variable
    % elevation was given, it will also be assigned.
    V_extrude = V;
    V_extrude(:,3) = options.elevation(:);
else                            % THICKNESS was specified
    % Get vertex normals the hard or the easy way
    if options.oldVersion
        facets = V';
        facets = permute(reshape(facets(:,F'), 3, 3, []),[2 1 3]);
        allEdgeVecs = facets([2 3 1],:,:) - facets(:,:,:);
        allFacetNormals =  bsxfun(@times, allEdgeVecs(1,[2 3 1],:), allEdgeVecs(2,[3 1 2],:)) - ...
            bsxfun(@times, allEdgeVecs(2,[2 3 1],:), allEdgeVecs(1,[3 1 2],:));
        allFacetNormals = bsxfun(@rdivide, allFacetNormals, sqrt(sum(allFacetNormals.^2,2)));
        facesByVertex = T.vertexAttachments;
        Vnormals = zeros(size(V));
        for i = 1:length(facesByVertex) %#ok<*FXUP>
            Vnormals(i,:) =  mean(allFacetNormals(:,:,facesByVertex{i}),3);
        end
        Vnormals = bsxfun(@rdivide, Vnormals, sqrt(sum(Vnormals.^2,2)));
    else
        Vnormals = T.vertexNormal;
    end
    % Extrudes by thickness in each normal direction.
    % bsxfun is used in case the user wants to supply variables offsets by
    % each vertex.
    V_extrude = V + bsxfun(@times, Vnormals, options.thickness(:));
end

% If a scalar elevation was supplied, we can save file size (or triangle
% count) and define the base by only its boundary vertices.
if isscalar(options.elevation)
    V_wall = [V(boundVerts,:); V_extrude(boundVerts,:)];
else % thickness was specified
    V_wall = [V(boundVerts,:); V_extrude(boundVerts,:)];
end

% Number of wall vertices on each surface (nwv).
nwv = length(V_wall)/2;
% Allocate memory for wallFaces.
F_wall = zeros(2*(nwv-1),3);
% Define the faces.
for k = 1:nwv-1
    F_wall(k      ,:) = [k+1  ,k      ,k+nwv];
    F_wall(k+nwv-1,:) = [k+nwv,k+1+nwv,k+1];
end

% Let's use the first vertex to test if faces are pointed in/out
testNormal = cross(...
    V(F(1,2),:) - V(F(1,1),:),...
    V(F(1,3),:) - V(F(1,1),:));
if ~isempty(options.elevation)
    firstVertZoffset = options.elevation(1) - V(1,3);
else
    firstVertZoffset = options.thickness(1);
end
% If the first face is pointing in the same direction as the direction of
% offset, we will have all faces pointing "in". We want them pointing "out"
if sign(testNormal(3)) == sign(firstVertZoffset)
    F = fliplr(F);
end

if isscalar(options.elevation)     % SCALAR ELEVATION was specified
    % Each boundary vertex forms a triangle with its right-hand neighbor
    % and a newly formed centroid of the extruded face.
    n = length(boundVerts);
    V_extrude = [mean(V_extrude,1); V_extrude(boundVerts,:)];% prepend centroid.
    % Ensure extruded faces are properly oriented.
    testNormal = cross(...
        V_extrude(2,:)-V_extrude(1,:),...
        V_extrude(3,:)-V_extrude(1,:));
    if sign(testNormal(3)) == sign(options.elevation)
        F_extrude = [ones(n-1,1),(2:n)',[(3:n)';2]];
    else
        F_extrude = [[(3:n)';2],(2:n)',ones(n-1,1)];
    end
else % Thickness or variable elevation was specified
    % Simply ensure the extruded faces are oriented opposite the originals
    F_extrude = fliplr(F);
end

% Compile 3 sets of faces together
allVertices = [V; V_wall; V_extrude];
allFaces = [F;                           % Use original faces
    F_wall+size(V,1);                    % Add wall faces
    F_extrude+size(V,1)+size(V_wall,1)]; % Add opposite faces (flipped)

% Ouput based on requested variables.
varargout = {};
if nargout == 0
  %figure;
  hold on;
  view(3);
  axis vis3d;
  patch('Faces'    ,F        ,...
        'Vertices' ,V        ,...
        'FaceColor','r'      );
  patch('Faces'    ,F_wall   ,...
        'Vertices' ,V_wall   ,...
        'FaceColor','g'      );
  patch('Faces'    ,F_extrude,...
        'Vertices' ,V_extrude,...
        'FaceColor','b'      );
  hold off;
%   set(gca,'zlim',[min(allVertices(:,3)),max(allVertices(:,3))]);
elseif nargout == 1
  varargout = {struct('faces',allFaces,'vertices',allVertices)};
elseif nargout >= 2
  varargout = {allFaces, allVertices};
end


%% Input handling subfunctions
function [faces, vertices, options] = parseInputs(varargin)
% Determine input type
if isstruct(varargin{1}) % surf2solid(FVstruct, ...)
    if ~all(isfield(varargin{1},{'vertices','faces'}))
        error( 'Variable p must be a faces/vertices structure' );
    end
    faces = varargin{1}.faces;
    vertices = varargin{1}.vertices;
    options = parseOptions(varargin{2:end});
    
elseif isnumeric(varargin{1})
    firstNumInput = cellfun(@isnumeric,varargin);
    firstNumInput(find(~firstNumInput,1):end) = 0; % Only consider numerical input PRIOR to the first non-numeric
    numericInputCnt = nnz(firstNumInput);
    
    options = parseOptions(varargin{numericInputCnt+1:end});
    switch numericInputCnt
        case 3 % surf2solid(X, Y, Z, ...)
            % Extract the matrix Z
            Z = varargin{3};
            
            % Convert scalar XY to vectors
            ZsizeXY = fliplr(size(Z));
            for i = 1:2
                if isscalar(varargin{i})
                    varargin{i} = (0:ZsizeXY(i)-1) * varargin{i};
                end                    
            end
            
            % Extract X and Y
            if isequal(size(Z), size(varargin{1}), size(varargin{2}))
                % X,Y,Z were all provided as matrices
                [X,Y] = varargin{1:2};
            elseif numel(varargin{1})==ZsizeXY(1) && numel(varargin{2})==ZsizeXY(2)
                % Convert vector XY to meshgrid
                [X,Y] = meshgrid(varargin{1}, varargin{2});
            else
                error('surf2solid:badinput', 'Unable to resolve X and Y variables');
            end
            
            % Convert to faces/vertices
            if strcmp(options.triangulation,'delaunay')
                faces = delaunay(X,Y);
                vertices = [X(:) Y(:) Z(:)];
            else
                if ~exist('mesh2tri','file')
                    error('surf2solid:missing', '"mesh2tri" is required to convert X,Y,Z matrices to STL. It can be downloaded from:\n%s\n',...
                        'http://www.mathworks.com/matlabcentral/fileexchange/28327')
                end
                [faces, vertices] = mesh2tri(X, Y, Z, options.triangulation);
            end
            
        case 2 % surf2solid(FACES, VERTICES, ...)
            faces = varargin{1};
            vertices = varargin{2};
            
        otherwise
            error('surf2solid:badinput', 'Unable to resolve input types.');
    end
end
% Ensure *some* information is there to make a thickness
if isempty(options.thickness) && isempty(options.elevation)
    options.elevation = min(vertices(:,3)) - 0.1 * (max(vertices(:,3))-min(vertices(:,3)));
end

function options = parseOptions(varargin)
IP = inputParser;
IP.addParamValue('triangulation', 'delaunay', @ischar);
IP.addParamValue('elevation',[],@isnumeric)
IP.addParamValue('thickness',[],@isnumeric)
IP.parse(varargin{:});
options = IP.Results;

%% INCLUDED FUNCTIONS %%
function [F,V]=mesh2tri(X,Y,Z,tri_type)
[J,I]=meshgrid(1:1:size(X,2)-1,1:1:size(X,1)-1);
switch tri_type
    case 'f'%Forward slash
        TRI_I=[I(:),I(:)+1,I(:)+1;  I(:),I(:),I(:)+1];
        TRI_J=[J(:),J(:)+1,J(:);   J(:),J(:)+1,J(:)+1];
        F = sub2ind(size(X),TRI_I,TRI_J);
    case 'b'%Back slash
        TRI_I=[I(:),I(:)+1,I(:);  I(:)+1,I(:)+1,I(:)];
        TRI_J=[J(:)+1,J(:),J(:);   J(:)+1,J(:),J(:)+1];
        F = sub2ind(size(X),TRI_I,TRI_J);
    case 'x'%Cross
        TRI_I=[I(:)+1,I(:);  I(:)+1,I(:)+1;  I(:),I(:)+1;    I(:),I(:)];
        TRI_J=[J(:),J(:);    J(:)+1,J(:);    J(:)+1,J(:)+1;  J(:),J(:)+1];
        IND=((numel(X)+1):numel(X)+prod(size(X)-1))';
        F = sub2ind(size(X),TRI_I,TRI_J);
        F(:,3)=repmat(IND,[4,1]);
        Fe_I=[I(:),I(:)+1,I(:)+1,I(:)]; Fe_J=[J(:),J(:),J(:)+1,J(:)+1];
        Fe = sub2ind(size(X),Fe_I,Fe_J);
        Xe=mean(X(Fe),2); Ye=mean(Y(Fe),2);  Ze=mean(Z(Fe),2);
        X=[X(:);Xe(:)]; Y=[Y(:);Ye(:)]; Z=[Z(:);Ze(:)];
end
V=[X(:),Y(:),Z(:)];
end
end
end
end

