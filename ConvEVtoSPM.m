function ConvEVtoSPM(ThreeCols,CondNames,MulConMat,varargin)
% Convert a set of FSL 3 column EV definitions to variables for SPM's "multiple condition"
% FORMAT ConvEVtoSPM(ThreeCols,CondNames,MulConMat,ScanDur,EventDur)
% 
% ThreeCols  - Cell array of 3column text filenames.
%              Parametric modulations must be amrked by nesting in a cell
%              array; e.g. 
%                     ThreeCols={'ev1.dat',{'ev2.dat','ev2mo1.dat','ev2mo2.dat'},{'ev3.dat','ev3mo.dat'}}
%              In each set, FIRST 3col file should have no parametric
%              modulation. 
% CondNames  - Cell array of condition names.
%              If any ThreeCols have nested cell arrays, the CondNames cell array must follow the same pattern.
% MulConMat  - Name of matfile to write out, suitable for passing to "multiple condition" portion of fMRI designs
% ScanDur    - Duration of the session in seconds minus 1 TR; used for placing a dummy event at the end of the time series.
%              Used to ensure valid EV definition even if a 3 column file is empty (i.e.  "0 0 0").
% EventDur   - Use this as the common event duration for all conditions, over-riding the 3-col information.
%
% If CondNames is empty, will try to construct names from ThreeCol filenames.
%
%__________________________________________________________________________
% Author: T. Nichols
% Version: $Id$

if nargin>=4, ScanDur=varargin{1}; end
if nargin>=5, EventDur=varargin{2}; end

try, ScanDur;
catch
  ScanDur=[];
end
try, EventDur
catch
  EventDur=[];
end

%
%  Make a guess of the names
%
if isempty(CondNames)
  for i=1:length(ThreeCols)
    if isstr(ThreeCols{i})
      CondNames{i}=spm_str_manip(ThreeCols{i},'tr');
    else
      for ii=1:length(ThreeCols{i})
	tmp{ii}=spm_str_manip(ThreeCols{i}{ii},'tr');
      end
      CondNames{i}=tmp;
    end
  end
end

%
%  Just some rudimentary tests
%
if ~iscell(ThreeCols) || ~iscell(CondNames) ~~ length(ThreeCols)~=length(CondNames)
  error('Bad inputs!')
end

%
%  Go!
%

pmod=repmat(struct('name',{},'param',{},'poly',{}),1,0);

for i=1:length(ThreeCols)
  if isstr(ThreeCols{i})
    names{i}=CondNames{i};
    EV=load(ThreeCols{i});
  else
    names{i}=CondNames{i}{1};
    EV=load(ThreeCols{i}{1});
  end
  if size(EV,1)==1 && all(EV==[0 0 0])
    if isempty(ScanDur)
      error('Scan duration (ScanDur) is not specified, but 3col file is empty/null')
    end
    onsets{i}=[ScanDur];
    durations{i}=[0];
  else

    onsets{i}=EV(:,1);
    if isempty(EventDur)
      %% This will use the durations in the 3col files....
      durations{i}=EV(:,2);
    else
      durations{i}=repmat(EventDur,size(EV(:,2)));
    end

    ii=1;
    if isstr(ThreeCols{i})
      Mx=max(EV(:,3));   Mn=min(EV(:,3));    
      if (Mx-Mn > 1e-4) 
	warning(['Modulation ignored on: ' ThreeCols{i}])
      end
    else
      % Modulations
      EV1=EV;
      for ii=2:length(ThreeCols{i})
	EV=load(ThreeCols{i}{ii});
	if size(EV1,1)~=size(EV,1) || ~all(EV1(:,1)==EV(:,1))
	  error(sprintf('EV don''t match!  "%s" (%s) "%s" (%s)',...
			CondNames{i}{1},ThreeCols{i}{1},CondNames{i}{ii},ThreeCols{i}{ii}))
	end
	pmod(i).name{ii-1}  = CondNames{i}{ii};
	pmod(i).param{ii-1} = EV(:,3);
	pmod(i).poly{ii-1}  = 1;
      end
    end

  end
end

if length(pmod)==0
  save(MulConMat,'names','onsets','durations')
else
  save(MulConMat,'names','onsets','durations','pmod')
end

