classdef IJetsVisualization < SwigRef
  methods
    function this = swig_this(self)
      this = iDynTreeMEX(3, self);
    end
    function delete(self)
      if self.swigPtr
        iDynTreeMEX(1614, self);
        self.swigPtr=[];
      end
    end
    function varargout = setJetsFrames(self,varargin)
      [varargout{1:nargout}] = iDynTreeMEX(1615, self, varargin{:});
    end
    function varargout = getNrOfJets(self,varargin)
      [varargout{1:nargout}] = iDynTreeMEX(1616, self, varargin{:});
    end
    function varargout = getJetDirection(self,varargin)
      [varargout{1:nargout}] = iDynTreeMEX(1617, self, varargin{:});
    end
    function varargout = setJetDirection(self,varargin)
      [varargout{1:nargout}] = iDynTreeMEX(1618, self, varargin{:});
    end
    function varargout = setJetColor(self,varargin)
      [varargout{1:nargout}] = iDynTreeMEX(1619, self, varargin{:});
    end
    function varargout = setJetsDimensions(self,varargin)
      [varargout{1:nargout}] = iDynTreeMEX(1620, self, varargin{:});
    end
    function varargout = setJetsIntensity(self,varargin)
      [varargout{1:nargout}] = iDynTreeMEX(1621, self, varargin{:});
    end
    function self = IJetsVisualization(varargin)
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if ~isnull(varargin{1})
          self.swigPtr = varargin{1}.swigPtr;
        end
      else
        error('No matching constructor');
      end
    end
  end
  methods(Static)
  end
end