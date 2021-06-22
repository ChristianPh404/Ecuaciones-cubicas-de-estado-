classdef VanDerWaalsEos < eos.multicomp.CubicEosBase
    % VanDerWaalsEos Van der Waals equation of state
    %
    %  This class provides methods to calculate thermodynamic properties
    %  based on Van der Waals equation of state.
    
    methods (Static)
        function coeffs = zFactorCubicEq(A,B)
            % Computes coefficients of Z-factor cubic equation
            %
            % Parameters
            % ----------
            % A : Reduced attraction parameter
            % B : Reduced repulsion parameter
            %
            % Returns
            % -------
            % coeffs : Coefficients of the cubic equation of Z-factor
            arguments
                A (1,1) {mustBeNumeric}
                B (1,1) {mustBeNumeric}
            end
            coeffs = [1, -B - 1, A, -A*B];
        end
        function lnPhi = lnFugacityCoeff(z,s)
            % Computes natural log of fugacity coefficients
            %
            % Parameters
            % ----------
            % z : Z-factor
            % s : State
            %
            % Returns
            % -------
            % lnPhi : Natural log of fugacity coefficients
            arguments
                z (1,1) {mustBeNumeric}
                s struct
            end
            A = s.A;
            B = s.B;
            Aij = s.Aij;
            Bi = s.Bi;
            x = s.x;
            lnPhi = Bi/B*(z - 1) - log(z - B) - A/z*(2*(Aij*x)/A - Bi/B);
        end
        function P = pressureImpl(T,V,a,b)
            % Compute pressure
            %
            % Parameters
            % ----------
            % T : Temperature [K]
            % V : Volume [m3]
            % a : Attraction parameter
            % b : Repulsion parameter
            %
            % Returns
            % -------
            % P : Pressure [Pa]
            R = eos.ThermodynamicConstants.Gas;
            P = R*T./(V - b) - a./V.^2;
        end
        function coeffs = dPdTPolyEq(T,a,b)
            % Compute the coefficients of the polynomial of dPdT = 0.
            %
            % coeffs = dPdTPolyEq(a,b)
            %
            % Parameters
            % ----------
            % T : Temperature [K]
            % a : Attraction parameter
            % b : Repulsion parameter
            %
            % Returns
            % -------
            % coeffs : Coefficients of the polynomial
            R = eos.ThermodynamicConstants.Gas;
            coeffs = [R*T, -2*a, 4*a*b, -2*a*b^2];
        end
    end
    methods
        function obj = VanDerWaalsEos(Pc,Tc,Mw,K)
            % Constructs VDW EOS
            %
            % Parameters
            % ----------
            % Pc : Critical pressure [Pa]
            % Tc : Critical temperature [K]
            % Mw : Molecular weight [g/mol]
            % K  : Binary interaction parameters
            arguments
                Pc (:,1) {mustBeNumeric}
                Tc (:,1) {mustBeNumeric}
                Mw (:,1) {mustBeNumeric}
                K (:,:) {mustBeNumeric}
            end
            obj@eos.multicomp.CubicEosBase(0.421875,0.125,Pc,Tc,Mw,K);
        end
        function obj = setParams(obj,Pc,Tc,Mw,K)
            % Set parameters
            %
            % Parameters
            % ----------
            % Pc : Critical pressure [Pa]
            % Tc : Critical temperature [K]
            % Mw : Molecular weight [g/mol]
            % K  : Binary interaction parameters (optional)
            arguments
                obj {mustBeA(obj,'eos.multicomp.VanDerWaalsEos')}
                Pc (:,1) {mustBeNumeric}
                Tc (:,1) {mustBeNumeric}
                Mw (:,1) {mustBeNumeric}
                K (:,:) {mustBeNumeric}
            end
            obj = setParams@eos.multicomp.CubicEosBase(obj,Pc,Tc,Mw,K);
        end
        function alpha = temperatureCorrectionFactor(~,~)
            alpha = 1;
        end
    end
end