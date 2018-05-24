% REBUFFER_DELAY   バッファリングとアンバッファリング操作によって発生する
%                  遅れのサンプル数を出力
%
% D = REBUFFER_DELAY(F,N,V) は、マルチタスクモードで、V のオーバーラップ
% サンプルとし、入力バッファサイズ F と出力バッファサイズ N を与えた
% ときの遅れのサンプル数を出力します。
%
% D = REBUFFER_DELAY(F,N,V,'singletasking') は、シングルタスクモードでの
% 遅れのサンプル数を出力します。


%   Copyright 1995-2004 The MathWorks, Inc.
