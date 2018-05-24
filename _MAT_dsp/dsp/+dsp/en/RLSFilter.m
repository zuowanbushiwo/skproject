classdef RLSFilter< handle
%RLSFilter Compute output, error and coefficients using Recursive Least
%          Squares (RLS) adaptive algorithm.
%
%   HRLS = dsp.RLSFilter returns an adaptive FIR filter System object(TM),
%   HRLS, that computes the filtered output, filter error and the filter
%   weights for a given input and desired signal using the Recursive Least
%   Squares (RLS) algorithm.
%
%   HRLS = dsp.RLSFilter('PropertyName', PropertyValue, ...) returns an RLS
%   filter System object, HRLS, with each specified property set to the
%   specified value.
%
%   HRLS = dsp.RLSFilter(LEN, 'PropertyName', PropertyValue, ...) returns
%   an RLS filter System object, HRLS, with the Length property set to LEN,
%   and other specified properties set to the specified values.
%
%   Step method syntax:
%
%   [Y, ERR] = step(HRLS, X, D) filters the input X, using D as the desired
%   signal, and returns the filtered output in Y and the filter error in
%   ERR. The System object estimates the filter weights needed to minimize
%   the error between the output signal and the desired signal. These
%   filter weights can be obtained by accessing the 'Coefficients' property
%   after calling the 'step' method by HRLS.Coefficients.
%
%   RLSFilter methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create RLSFilter object with same property values
%   isLocked - Locked status (logical)
%   reset    - Reset the internal states to initial conditions
%
%   RLSFilter properties:
%
%   Method                      - Method to calculate filter coefficients
%   Length                      - Length of filter coefficients vector
%   SlidingWindowBlockLength    - Width of the sliding window
%   ForgettingFactor            - RLS Forgetting factor
%   InitialCoefficients         - Initial coefficients of the filter
%   InitialInverseCovariance    - Initial inverse covariance
%   InitialSquareRootInverseCovariance  - Initial square root inverse
%                                         covariance
%   InitialSquareRootCovariance - Initial square root covariance
%   LockCoefficients            - Locks the coefficient updates (logical)
%
%   % EXAMPLE #1: System identification of an FIR filter
%      hrls1 = dsp.RLSFilter(11, 'ForgettingFactor', 0.98);
%      hfilt = dsp.FIRFilter('Numerator',fir1(10, .25)); % Unknown System
%      x = randn(1000,1);                       % input signal
%      d = step(hfilt, x) + 0.01*randn(1000,1); % desired signal
%      [y,e] = step(hrls1, x, d);
%      w = hrls1.Coefficients;
%      subplot(2,1,1), plot(1:1000, [d,y,e]);
%      title('System Identification of an FIR filter');
%      legend('Desired', 'Output', 'Error');
%      xlabel('time index'); ylabel('signal value');
%      subplot(2,1,2); stem([hfilt.Numerator; w].');
%      legend('Actual','Estimated'); 
%      xlabel('coefficient #'); ylabel('coefficient value');
%
%   % EXAMPLE #2: Noise cancellation
%      hrls2 = dsp.RLSFilter('Length', 11, 'Method', 'Householder RLS');
%      hfilt2 = dsp.FIRFilter('Numerator',fir1(10, [.5, .75]));
%      x = randn(1000,1);                           % Noise
%      d = step(hfilt2, x) + sin(0:.05:49.95)';     % Noise + Signal
%      [y, err] = step(hrls2, x, d);
%      subplot(2,1,1), plot(d), title('Noise + Signal');
%      subplot(2,1,2), plot(err), title('Signal');
%
%   See also dsp.LMSFilter, dsp.AffineProjectionFilter, dsp.FIRFilter,
%            dsp.FastTransversalFilter.

 
%   Copyright 1995-2013 The MathWorks, Inc.

    methods
        function out=RLSFilter
            % Support name-value pair arguments as well as alternatively
            % allow 'Length' to be value only argument.
        end

        function getDiscreteStateImpl(in) %#ok<MANU>
        end

        function getFilterParameterStruct(in) %#ok<MANU>
        end

        function getNumInputsImpl(in) %#ok<MANU>
            % Specify number of System inputs
        end

        function getNumOutputsImpl(in) %#ok<MANU>
            % Specify number of System outputs
        end

        function initializeVariables(in) %#ok<MANU>
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function loadObjectImpl(in) %#ok<MANU>
        end

        function processTunedPropertiesImpl(in) %#ok<MANU>
            % Whenever ForgettingFactor is changed, update the private
            % structure that stores the type casted version of it
        end

        function resetImpl(in) %#ok<MANU>
            % Local copy of the required properties
        end

        function saveObjectImpl(in) %#ok<MANU>
        end

        function setDiscreteStateImpl(in) %#ok<MANU>
        end

        function setupImpl(in) %#ok<MANU>
            % Setting InputDataType to be the data type of x and setting
            % the FilterParameters structure based on that.
        end

        function stepImpl(in) %#ok<MANU>
            % Load states, properties and initialize variables
        end

        function updateBuffer(in) %#ok<MANU>
            % Function to assign the current input by shifting the buffer down
        end

        function validateInputsImpl(in) %#ok<MANU>
            % Validating the size of the inputs x and d. Inputs must be
            % vectors.
        end

        function validatePropertiesImpl(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %Coefficients Current coefficients of the filter
        %   This property stores the current coefficients of the filter
        %   as a row vector of length equal to the Length property value.
        %   This property is initialized to the values of
        %   InitialCoefficients property.
        Coefficients;

        %DesiredStates Current desired states of the filter
        %   This property stores the current desired signal states of the
        %   adaptive filter as a column vector. Its length is equal to the
        %   SlidingWindowBlockLength property value. This property applies
        %   only when the Method is 'Sliding-window RLS' or 'Householder
        %   sliding-window RLS'. This property is initialized to a zero
        %   vector of appropriate length.
        DesiredStates;

        %FilterParameters Private property to store the filter parameters
        %   This is a private MATLAB structure that stores all the filter
        %   parameters in the appropriate data type. For RLSFilter System
        %   object, ForgettingFactor and LockCoefficients are the filter
        %   parameters. This property is initialized in the setup method.
        FilterParameters;

        %ForgettingFactor RLS Forgetting factor
        %   Specify the RLS forgetting factor as a scalar positive numeric
        %   value less than or equal to 1. Setting this property value to 1
        %   denotes infinite memory while adapting to find the new filter.
        %   The default value of this property is 1.
        ForgettingFactor;

        %InitialCoefficients Initial coefficients of the filter
        %   Specify the initial values of the FIR adaptive filter
        %   coefficients as a scalar or a vector of length equal to the
        %   Length property value. The default value of this property is 0.
        InitialCoefficients;

        %InitialInverseCovariance Initial inverse covariance
        %   Specify the initial values of the inverse covariance matrix of
        %   the input signal. This property must either be a scalar or a
        %   square matrix with each dimension equal to the Length property
        %   value. If a scalar value is set, the InverseCovariance property
        %   will be initialized to a diagonal matrix with diagonal elements
        %   equal to that scalar value. This property applies only when the
        %   Method property is set to 'Conventional RLS' or 'Sliding-window
        %   RLS'. The default value of this property is 1000.
        InitialInverseCovariance;

        %InitialSquareRootCovariance Initial square root covariance
        %   Specify the initial values of the square root covariance
        %   matrix of the input signal. This property must either be a
        %   scalar or a square matrix with each dimension equal to the
        %   Length property value. If a scalar value is set, the
        %   SquareRootCovariance property will be initialized to a diagonal
        %   matrix with diagonal elements equal to that scalar value. This
        %   property applies only when the Method property is set to
        %   'QR-decomposition RLS'. The default value of this property is
        %   sqrt(1/1000).
        InitialSquareRootCovariance;

        %InitialSquareRootInverseCovariance Initial square root inverse
        %                                   covariance
        %   Specify the initial values of the square root inverse
        %   covariance matrix of the input signal. This property must
        %   either be a scalar or a square matrix with each dimension equal
        %   to the Length property value. If a scalar value is set, the
        %   SquareRootInverseCovariance property will be initialized to a
        %   diagonal matrix with diagonal elements equal to that scalar
        %   value. This property applies only when the Method property is
        %   set to 'Householder RLS' or 'Householder sliding-window RLS'.
        %   The default value of this property is sqrt(1000).
        InitialSquareRootInverseCovariance;

        %InputDataType Data type of the inputs
        %   This is a private property that stores the data type of the
        %   inputs and it is used to set the data type of all the
        %   DiscreteState properties and the outputs.
        InputDataType;

        %InverseCovariance Current inverse covariance
        %   This property stores the current inverse covariance matrix of
        %   the input signal. It is a square matrix with each dimension
        %   equal to the Length property value. This property applies only
        %   when the Method property is 'Conventional RLS' or
        %   'Sliding-window RLS'. This property is initialized to the
        %   values of InitialInverseCovariance property.
        InverseCovariance;

        %KalmanGain Current Kalman gain vector
        %   This property stores the current Kalman gain vector. It is a
        %   column vector of length equal to the Length property. This
        %   property does not apply when the Method property is
        %   'QR-decomposition RLS'. This property is initialized to a zero
        %   vector of appropriate length.
        KalmanGain;

        %Length Length of filter coefficients vector
        %   Specify the length of the FIR filter coefficients vector as a
        %   scalar positive integer value. The default value of this
        %   property is 32.
        Length;

        %LockCoefficients Lock the coefficient updates
        %   Specify whether the filter coefficient values should be locked.
        %   By default, the value of this property is false, and the object
        %   continuously updates the filter coefficients. When this
        %   property is set to true, the filter coefficients are not
        %   updated and their values remain at the current value.
        LockCoefficients;

        %Method Method to calculate the filter coefficients
        %   Specify the method used to calculate filter coefficients as one
        %   of [{'Conventional RLS'} | 'Householder RLS' | 'Sliding-window
        %   RLS' | 'Householder sliding-window RLS' | 'QR-decomposition
        %   RLS'].
        Method;

        %ModifiedCrossCorrelation Modified input cross correlation vector
        %   This property stores the current modified input cross
        %   correlation vector, which is the square root inverse covariance
        %   multiplied by the time-average cross-correlation of the current
        %   input signal. This property is a column vector of length equal
        %   to the Length property. This property applies only when the
        %   Method property is 'QR-decomposition RLS'. This property is
        %   initialized to a zero vector of appropriate length.
        ModifiedCrossCorrelation;

        %SlidingWindowBlockLength Width of the sliding window
        %   Specify the width of the sliding window as a scalar positive
        %   integer value greater than equal to the Length property value.
        %   This property is applicable only when the Method property is
        %   set to 'Sliding-window RLS' or 'Householder sliding-window
        %   RLS'. The default value of this property is 48.
        SlidingWindowBlockLength;

        %SquareRootCovariance Current square root covariance
        %   This property stores the current square root covariance matrix
        %   of the input signal. It is a square matrix with each dimension
        %   equal to the Length property value. This property applies only
        %   when the Method property is 'QR-decomposition RLS'. This
        %   property is initialized to the values of
        %   InitialSquareRootCovariance property.
        SquareRootCovariance;

        %SquareRootInverseCovariance Current square root inverse covariance
        %   This property stores the current square root inverse covariance
        %   matrix of the input signal. It is a square matrix with each
        %   dimension equal to the Length property value. This property
        %   applies only when the Method property is 'Householder RLS' or
        %   'Householder sliding-window RLS'. This property is initialized
        %   to the values of InitialSquareRootInverseCovariance property.
        SquareRootInverseCovariance;

        %States Current internal states of the filter
        %   This property stores the current states of the filter as a
        %   column vector. Its length is equal to the Length property when
        %   the Method is 'Conventional RLS', 'Householder RLS', or
        %   'QR-decomposition RLS' and is equal to the value of (Length +
        %   SlidingWindowBlockLength) when the Method is 'Sliding-window
        %   RLS' or 'Householder sliding-window RLS'. This property is
        %   initialized to a zero vector of appropriate length.
        States;

    end
end
