% % % % GeneratePridictedData


LATERAL_POLE = 0.099064;
LATERAL_ZERO = 0.03508;
HEAVE_POLE = 0.092322;
HEAVE_ZERO = 0.028394;
SURGE_POLE = 0.097584;
SURGE_ZERO = 0.033943;


% % clear the data, done in the original mooddots
% % m_interpHeave.clear(); m_interpSurge.clear(); m_interpLateral.clear();


% m_interpLateral = DifferenceFunc(trajinfo, LATERAL_POLE, LATERAL_ZERO, 'Lateral');
% m_interpHeave = DifferenceFunc(trajinfo, HEAVE_POLE, HEAVE_ZERO, 'Heave');
% m_interpSurge = DifferenceFunc(trajinfo, SURGE_POLE, SURGE_ZERO, 'Surge');

trajinfo(1,7).data = DifferenceFunc(trajinfo, LATERAL_POLE, LATERAL_ZERO, 'Lateral');
trajinfo(1,9).data = DifferenceFunc(trajinfo, HEAVE_POLE, HEAVE_ZERO, 'Heave');
trajinfo(1,8).data = DifferenceFunc(trajinfo, SURGE_POLE, SURGE_ZERO, 'Surge');

clear LATERAL_POLE LATERAL_ZERO HEAVE_POLE HEAVE_ZERO SURGE_POLE SURGE_ZERO


% figure; 
% plot(m_interpHeave)



% % 
% % m_interpLateral = DifferenceFunc(trajinfo(1,7).data, LATERAL_POLE, LATERAL_ZERO, 'Lateral');
% % m_interpHeave = DifferenceFunc(trajinfo(1,9).data, HEAVE_POLE, HEAVE_ZERO, 'Heave');
% % m_interpSurge = DifferenceFunc(trajinfo(1,8).data, SURGE_POLE, SURGE_ZERO, 'Surge');