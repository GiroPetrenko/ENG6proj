classdef audio_samp_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        ReverseButton                   matlab.ui.control.Button
        PlayButton                      matlab.ui.control.Button
        ByZhuoxuanShiJustinCanasNghiaNguyenLabel  matlab.ui.control.Label
        ENG6AudioSamplerLabel           matlab.ui.control.Label
        AdjustSampleRateButton          matlab.ui.control.Button
        SampleRateadjkHzEditField       matlab.ui.control.NumericEditField
        SampleRateadjkHzEditFieldLabel  matlab.ui.control.Label
        CropAudioButton                 matlab.ui.control.Button
        EndsEditField                   matlab.ui.control.NumericEditField
        EndsEditFieldLabel              matlab.ui.control.Label
        BeginsEditField                 matlab.ui.control.NumericEditField
        BeginsEditFieldLabel            matlab.ui.control.Label
        SquareButton                    matlab.ui.control.Button
        SawtoothButton                  matlab.ui.control.Button
        SineButton                      matlab.ui.control.Button
        SynthButton                     matlab.ui.control.Button
        DFactorKnob                     matlab.ui.control.Knob
        DFactorKnobLabel                matlab.ui.control.Label
        PFactorKnob                     matlab.ui.control.Knob
        PFactorKnobLabel                matlab.ui.control.Label
        TempoKnob                       matlab.ui.control.Knob
        TempoKnobLabel                  matlab.ui.control.Label
        VolumeKnob                      matlab.ui.control.Knob
        VolumeKnobLabel                 matlab.ui.control.Label
        EQLabel                         matlab.ui.control.Label
        Label                           matlab.ui.control.Label
        HzSlider_5                      matlab.ui.control.Slider
        HzSlider_4                      matlab.ui.control.Slider
        HzSlider_3                      matlab.ui.control.Slider
        HzSlider_2                      matlab.ui.control.Slider
        HzSlider                        matlab.ui.control.Slider
        AmpRawGauge                     matlab.ui.control.LinearGauge
        AmpRawGaugeLabel                matlab.ui.control.Label
        LoadButton                      matlab.ui.control.Button
        L9Button                        matlab.ui.control.Button
        L8Button                        matlab.ui.control.Button
        L7Button                        matlab.ui.control.Button
        L6Button                        matlab.ui.control.Button
        L5Button                        matlab.ui.control.Button
        L4Button                        matlab.ui.control.Button
        L3Button                        matlab.ui.control.Button
        L2Button                        matlab.ui.control.Button
        L1Button                        matlab.ui.control.Button
        waveraw                         matlab.ui.control.UIAxes
        waveproc                        matlab.ui.control.UIAxes
    end

    methods (Access = public)
        function dog(app,d)
            disp(d)
        end
    end

    properties (Access = private)
        % Author: Zhuoxuan Shi / ENG 6
        MemAudioFS = 44100 % audio sample rate
        MemAudioFS_const = 44100 % base value for this program
        MemAudioArray
        g_audio = {[],[],[],[],[],[],[],[],[]} % Global audio cell array, element 1-9 -> 9 audio channels
        g_pointer = 1   % pointer to g_audio (this is matlab but im too used to C)
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: CropAudioButton
        function CropAudioButtonPushed(app, event)
            
            app.MemAudioArray = app.g_audio{app.g_pointer};

            initialValue = app.BeginsEditField.Value;
            endValue = app.EndsEditField.Value;
            initialSample = round(initialValue * app.MemAudioFS) + 1;
            endSample = round(endValue * app.MemAudioFS);

            disp(endSample);
            try
                app.g_audio{app.g_pointer} = app.MemAudioArray(initialSample:endSample, :);
            catch
                fig = uifigure;
                uialert(fig,"No Crop Possible!","Error",'CloseFcn',@(h,e) close(fig))
            end
            
        end

        % Button pushed function: LoadButton
        function LoadButtonPushed(app, event)
            % this logic: when loading button is pressed, audio is loaded
            % from file to the selected channel (Lx)
            [file, path] = uigetfile("*.wav");
            audio_path = fullfile(path,file);
            [tempAudio, tempFS] = audioread(audio_path);
            plot(app.waveraw, tempAudio);
            app.g_audio{app.g_pointer} = tempAudio;
            app.SampleRateadjkHzEditField.Value = (tempFS / 1000);        % displays audio loaded FS
            % !!! resampling is nesscary because MATLAB program playback
            % might be wrong!!!
        end

        % Button pushed function: SineButton
        function SineButtonPushed(app, event)
            % t = (1 : length(app.MeMaudioArray)) / app.MemAudioFS;
            % app.MemAudioFS = 44100;
            dog(app, 1);
            dt = 1/app.MemAudioFS;
            F = 1000; % audio freq
            t = (0:dt:1);   % stop time
            audioTemp = sin(2*pi*F*t);
            axis(app.waveproc, [0 0.01 -1 1])
            plot(app.waveproc, t, audioTemp);

            sineAud = audioplayer(audioTemp, app.MemAudioFS);
            playblocking(sineAud);

            app.g_audio{app.g_pointer} = audioTemp;
        end

        % Button pushed function: SawtoothButton
        function SawtoothButtonPushed(app, event)
            % T = 1000; 
            % fs = app.MemAudioFS;
            % t = 0:1/fs:T-1/fs;
            % x = sawtooth(2*pi*50*t);
            % app.MemAudioFS = 44100;
            dt = 1/app.MemAudioFS;
            F = 1000; % audio freq
            t = (0:dt:1);   % stop time
            audioTemp = sawtooth(2*pi*F*t);
            axis(app.waveproc, [0 0.01 -1 1])
            plot(app.waveproc, t, audioTemp);

            sawAud = audioplayer(audioTemp, app.MemAudioFS);
            playblocking(sawAud);

            app.g_audio{app.g_pointer} = audioTemp;
        end

        % Button pushed function: SquareButton
        function SquareButtonPushed(app, event)
            % x = app.MemAudioFS * app.MeMaudioArray;
            % app.MemAudioFS = 44100;
            dt = 1/app.MemAudioFS;
            F = 1000; % audio freq
            t = (0:dt:1);   % stop time
            audioTemp = square(2*pi*F*t);
            axis(app.waveproc, [0 0.01 -1 1])
            plot(app.waveproc, t, audioTemp);
            sqAud = audioplayer(audioTemp, app.MemAudioFS);
            playblocking(sqAud);

            app.g_audio{app.g_pointer} = audioTemp;
        end

        % Button pushed function: PlayButton
        function PlayButtonPushed(app, event)
            if size(app.g_audio{app.g_pointer}) == 0
                fig = uifigure;
                uialert(fig,"Empty Audio!","Error",'CloseFcn',@(h,e) close(fig))
            else
                clip_audio = audioplayer(app.g_audio{app.g_pointer}, app.MemAudioFS);
                app.AmpRawGauge.Value = (max(app.g_audio{app.g_pointer}) * 100);
                playblocking(clip_audio);
            end
            
        end

        % Button pushed function: L1Button
        function L1ButtonPushed(app, event)
            app.g_pointer = 1;
            plot(app.waveraw, app.g_audio{app.g_pointer});
            
        end

        % Button pushed function: L2Button
        function L2ButtonPushed(app, event)
            app.g_pointer = 2;
            plot(app.waveraw, app.g_audio{app.g_pointer});
        end

        % Button pushed function: L3Button
        function L3ButtonPushed(app, event)
            app.g_pointer = 3;
            plot(app.waveraw, app.g_audio{app.g_pointer});
        end

        % Button pushed function: L4Button
        function L4ButtonPushed(app, event)
            app.g_pointer = 4;
            plot(app.waveraw, app.g_audio{app.g_pointer});
        end

        % Button pushed function: L5Button
        function L5ButtonPushed(app, event)
            app.g_pointer = 5;
            plot(app.waveraw, app.g_audio{app.g_pointer});
        end

        % Button pushed function: L6Button
        function L6ButtonPushed(app, event)
            app.g_pointer = 6;
            plot(app.waveraw, app.g_audio{app.g_pointer});
        end

        % Button pushed function: L7Button
        function L7ButtonPushed(app, event)
            app.g_pointer = 7;
            plot(app.waveraw, app.g_audio{app.g_pointer});
        end

        % Button pushed function: L8Button
        function L8ButtonPushed(app, event)
            app.g_pointer = 8;
            plot(app.waveraw, app.g_audio{app.g_pointer});
        end

        % Button pushed function: L9Button
        function L9ButtonPushed(app, event)
            app.g_pointer = 9;
            plot(app.waveraw, app.g_audio{app.g_pointer});
        end

        % Value changed function: VolumeKnob
        function VolumeKnobValueChanged(app, event)
            value = app.VolumeKnob.Value;
            app.g_audio{app.g_pointer} = (app.g_audio{app.g_pointer} .* (value/100));
        end

        % Button pushed function: ReverseButton
        function ReverseButtonPushed(app, event)
            app.g_audio{app.g_pointer} = flip(app.g_audio{app.g_pointer});
        end

        % Value changed function: TempoKnob
        function TempoKnobValueChanged(app, event)
            value = app.TempoKnob.Value;
            app.MemAudioFS = (app.MemAudioFS_const * ((value/100)+1)) + 1; % min=1sps max = FS *2 + 1
        end

        % Value changed function: DFactorKnob
        function DFactorKnobValueChanged(app, event)
            value = app.DFactorKnob.Value;
            value = (value * app.MemAudioFS) / 100;    % its a very small and precise delay, might not be hear-able
            app.MemAudioArray = app.g_audio{app.g_pointer};
            [ch, sz] = size(app.g_audio{app.g_pointer});

            for v = value:sz
                orig = round(v-value+1);
                drift = round(v);
                app.MemAudioArray(orig) = app.MemAudioArray(orig) + 0.7*app.MemAudioArray(drift);
            end
            app.g_audio{app.g_pointer} = app.MemAudioArray;
        end

        % Button pushed function: AdjustSampleRateButton
        function AdjustSampleRateButtonPushed(app, event)
            app.MemAudioFS = round(str2double(app.SampleRateadjkHzEditField)*1000);
            fig = uifigure;
            uialert(fig,"Sample Rate is Adjusted!","Notice",'CloseFcn',@(h,e) close(fig))
        end

        % Value changed function: HzSlider
        function HzSliderValueChanged(app, event)
            value = app.HzSlider.Value;
            % 50 Hz EQ
            bp_1 = 1; % 1Hz
            bp_2 = 125; % should interleave with next EQ
            window = blackman(app.MemAudioFS+1);        % Why does matlab start at 1???
            fir_coeff = fir1(app.MemAudioFS, [bp_1 bp_2]/(app.MemAudioFS/2), "bandpass", window);
            % note for line above!!! Nyquist freq may change because
            % samp_rate is change-able
            %app.MemAudioArray = filtfilt(fir_coeff, 1, app.g_audio{app.g_pointer});
            % dont use filtfilt --> zero phase shift filter is very very
            % slow
            app.MemAudioArray = filter(fir_coeff, 1, app.g_audio{app.g_pointer});
            % axis(app.waveproc, [0 0.01 -1 1]);
            plot(app.waveproc, app.MemAudioArray);

            %app.g_audio{app.g_pointer} = app.MemAudioArray;

            clip_audio = audioplayer(app.MemAudioArray, app.MemAudioFS);
            playblocking(clip_audio);


        end

        % Value changed function: HzSlider_2
        function HzSlider_2ValueChanged(app, event)
            value = app.HzSlider_2.Value;
            bp_1 = 125; % 125Hz
            bp_2 = 400; % should interleave with next EQ
            window = blackman(app.MemAudioFS+1);        % Why does matlab start at 1???
            fir_coeff = fir1(app.MemAudioFS, [bp_1 bp_2]/(app.MemAudioFS/2), "bandpass", window);
            % note for line above!!! Nyquist freq may change because
            % samp_rate is change-able
            %app.MemAudioArray = filtfilt(fir_coeff, 1, app.g_audio{app.g_pointer});
            % dont use filtfilt --> zero phase shift filter is very very
            % slow
            app.MemAudioArray = filter(fir_coeff, 1, app.g_audio{app.g_pointer});
            % axis(app.waveproc, [0 0.01 -1 1]);
            plot(app.waveproc, app.MemAudioArray);

            %app.g_audio{app.g_pointer} = app.MemAudioArray;

            clip_audio = audioplayer(app.MemAudioArray, app.MemAudioFS);
            playblocking(clip_audio);
        end

        % Value changed function: HzSlider_3
        function HzSlider_3ValueChanged(app, event)
            value = app.HzSlider_3.Value;
            bp_1 = 400; % 
            bp_2 = 1250; % should interleave with next EQ
            window = blackman(app.MemAudioFS+1);        % Why does matlab start at 1???
            fir_coeff = fir1(app.MemAudioFS, [bp_1 bp_2]/(app.MemAudioFS/2), "bandpass", window);
            % note for line above!!! Nyquist freq may change because
            % samp_rate is change-able
            %app.MemAudioArray = filtfilt(fir_coeff, 1, app.g_audio{app.g_pointer});
            % dont use filtfilt --> zero phase shift filter is very very
            % slow
            app.MemAudioArray = filter(fir_coeff, 1, app.g_audio{app.g_pointer});
            % axis(app.waveproc, [0 0.01 -1 1]);
            plot(app.waveproc, app.MemAudioArray);

            %app.g_audio{app.g_pointer} = app.MemAudioArray;

            clip_audio = audioplayer(app.MemAudioArray, app.MemAudioFS);
            playblocking(clip_audio);
        end

        % Value changed function: HzSlider_4
        function HzSlider_4ValueChanged(app, event)
            value = app.HzSlider_4.Value;
            bp_1 = 1250; % 1250
            bp_2 = 4000; % should interleave with next EQ
            window = blackman(app.MemAudioFS+1);
            fir_coeff = fir1(app.MemAudioFS, [bp_1 bp_2]/(app.MemAudioFS/2), "bandpass", window);

            app.MemAudioArray = filter(fir_coeff, 1, app.g_audio{app.g_pointer});
            plot(app.waveproc, app.MemAudioArray);

            %app.g_audio{app.g_pointer} = app.MemAudioArray;

            clip_audio = audioplayer(app.MemAudioArray, app.MemAudioFS);
            playblocking(clip_audio);
        end

        % Value changed function: HzSlider_5
        function HzSlider_5ValueChanged(app, event)
            value = app.HzSlider_5.Value;
            bp_1 = 4000; % 1250
            bp_2 = 12000; % should interleave with next EQ
            window = blackman(app.MemAudioFS+1);
            fir_coeff = fir1(app.MemAudioFS, [bp_1 bp_2]/(app.MemAudioFS/2), "bandpass", window);

            app.MemAudioArray = filter(fir_coeff, 1, app.g_audio{app.g_pointer});
            plot(app.waveproc, app.MemAudioArray);

            %app.g_audio{app.g_pointer} = app.MemAudioArray;

            clip_audio = audioplayer(app.MemAudioArray, app.MemAudioFS);
            playblocking(clip_audio);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 800 600];
            app.UIFigure.Name = 'MATLAB App';

            % Create waveproc
            app.waveproc = uiaxes(app.UIFigure);
            title(app.waveproc, 'Wave Sample (Processed)')
            xlabel(app.waveproc, 'Samples (t)')
            ylabel(app.waveproc, 'Amp')
            zlabel(app.waveproc, 'Z')
            app.waveproc.XTick = [0 0.2 0.4 0.6 0.8 1];
            app.waveproc.YTick = [0 0.2 0.4 0.6 0.8 1];
            app.waveproc.Position = [501 416 300 185];

            % Create waveraw
            app.waveraw = uiaxes(app.UIFigure);
            title(app.waveraw, 'Wave Sample (Raw)')
            xlabel(app.waveraw, 'Samples (t)')
            ylabel(app.waveraw, 'Amp')
            zlabel(app.waveraw, 'Z')
            app.waveraw.Position = [1 416 300 185];

            % Create L1Button
            app.L1Button = uibutton(app.UIFigure, 'push');
            app.L1Button.ButtonPushedFcn = createCallbackFcn(app, @L1ButtonPushed, true);
            app.L1Button.FontWeight = 'bold';
            app.L1Button.Position = [321 533 54 52];
            app.L1Button.Text = 'L1';

            % Create L2Button
            app.L2Button = uibutton(app.UIFigure, 'push');
            app.L2Button.ButtonPushedFcn = createCallbackFcn(app, @L2ButtonPushed, true);
            app.L2Button.FontWeight = 'bold';
            app.L2Button.Position = [374 533 54 52];
            app.L2Button.Text = 'L2';

            % Create L3Button
            app.L3Button = uibutton(app.UIFigure, 'push');
            app.L3Button.ButtonPushedFcn = createCallbackFcn(app, @L3ButtonPushed, true);
            app.L3Button.FontWeight = 'bold';
            app.L3Button.Position = [427 533 54 52];
            app.L3Button.Text = 'L3';

            % Create L4Button
            app.L4Button = uibutton(app.UIFigure, 'push');
            app.L4Button.ButtonPushedFcn = createCallbackFcn(app, @L4ButtonPushed, true);
            app.L4Button.FontWeight = 'bold';
            app.L4Button.Position = [321 482 54 52];
            app.L4Button.Text = 'L4';

            % Create L5Button
            app.L5Button = uibutton(app.UIFigure, 'push');
            app.L5Button.ButtonPushedFcn = createCallbackFcn(app, @L5ButtonPushed, true);
            app.L5Button.FontWeight = 'bold';
            app.L5Button.Position = [374 482 54 52];
            app.L5Button.Text = 'L5';

            % Create L6Button
            app.L6Button = uibutton(app.UIFigure, 'push');
            app.L6Button.ButtonPushedFcn = createCallbackFcn(app, @L6ButtonPushed, true);
            app.L6Button.FontWeight = 'bold';
            app.L6Button.Position = [427 482 54 52];
            app.L6Button.Text = 'L6';

            % Create L7Button
            app.L7Button = uibutton(app.UIFigure, 'push');
            app.L7Button.ButtonPushedFcn = createCallbackFcn(app, @L7ButtonPushed, true);
            app.L7Button.FontWeight = 'bold';
            app.L7Button.Position = [321 431 54 52];
            app.L7Button.Text = 'L7';

            % Create L8Button
            app.L8Button = uibutton(app.UIFigure, 'push');
            app.L8Button.ButtonPushedFcn = createCallbackFcn(app, @L8ButtonPushed, true);
            app.L8Button.FontWeight = 'bold';
            app.L8Button.Position = [374 431 54 52];
            app.L8Button.Text = 'L8';

            % Create L9Button
            app.L9Button = uibutton(app.UIFigure, 'push');
            app.L9Button.ButtonPushedFcn = createCallbackFcn(app, @L9ButtonPushed, true);
            app.L9Button.FontWeight = 'bold';
            app.L9Button.Position = [427 431 54 52];
            app.L9Button.Text = 'L9';

            % Create LoadButton
            app.LoadButton = uibutton(app.UIFigure, 'push');
            app.LoadButton.ButtonPushedFcn = createCallbackFcn(app, @LoadButtonPushed, true);
            app.LoadButton.FontWeight = 'bold';
            app.LoadButton.Position = [307 394 68 23];
            app.LoadButton.Text = 'Load';

            % Create AmpRawGaugeLabel
            app.AmpRawGaugeLabel = uilabel(app.UIFigure);
            app.AmpRawGaugeLabel.HorizontalAlignment = 'center';
            app.AmpRawGaugeLabel.FontWeight = 'bold';
            app.AmpRawGaugeLabel.Position = [125 339 67 22];
            app.AmpRawGaugeLabel.Text = 'Amp (Raw)';

            % Create AmpRawGauge
            app.AmpRawGauge = uigauge(app.UIFigure, 'linear');
            app.AmpRawGauge.Position = [38 368 241 41];

            % Create HzSlider
            app.HzSlider = uislider(app.UIFigure);
            app.HzSlider.Limits = [0 1];
            app.HzSlider.Orientation = 'vertical';
            app.HzSlider.ValueChangedFcn = createCallbackFcn(app, @HzSliderValueChanged, true);
            app.HzSlider.Position = [39 167 3 150];
            app.HzSlider.Value = 1;

            % Create HzSlider_2
            app.HzSlider_2 = uislider(app.UIFigure);
            app.HzSlider_2.Limits = [0 1];
            app.HzSlider_2.Orientation = 'vertical';
            app.HzSlider_2.ValueChangedFcn = createCallbackFcn(app, @HzSlider_2ValueChanged, true);
            app.HzSlider_2.Position = [98 167 3 150];
            app.HzSlider_2.Value = 1;

            % Create HzSlider_3
            app.HzSlider_3 = uislider(app.UIFigure);
            app.HzSlider_3.Limits = [0 1];
            app.HzSlider_3.Orientation = 'vertical';
            app.HzSlider_3.ValueChangedFcn = createCallbackFcn(app, @HzSlider_3ValueChanged, true);
            app.HzSlider_3.Position = [157 167 3 150];
            app.HzSlider_3.Value = 1;

            % Create HzSlider_4
            app.HzSlider_4 = uislider(app.UIFigure);
            app.HzSlider_4.Limits = [0 1];
            app.HzSlider_4.Orientation = 'vertical';
            app.HzSlider_4.ValueChangedFcn = createCallbackFcn(app, @HzSlider_4ValueChanged, true);
            app.HzSlider_4.Position = [213 167 3 150];
            app.HzSlider_4.Value = 1;

            % Create HzSlider_5
            app.HzSlider_5 = uislider(app.UIFigure);
            app.HzSlider_5.Limits = [0 1];
            app.HzSlider_5.Orientation = 'vertical';
            app.HzSlider_5.ValueChangedFcn = createCallbackFcn(app, @HzSlider_5ValueChanged, true);
            app.HzSlider_5.Position = [267 167 3 150];
            app.HzSlider_5.Value = 1;

            % Create Label
            app.Label = uilabel(app.UIFigure);
            app.Label.FontSize = 18;
            app.Label.FontWeight = 'bold';
            app.Label.Position = [58 130 221 23];
            app.Label.Text = '50 / 250 / 600 / 2500/ 5000';

            % Create EQLabel
            app.EQLabel = uilabel(app.UIFigure);
            app.EQLabel.FontSize = 18;
            app.EQLabel.FontWeight = 'bold';
            app.EQLabel.Position = [143 108 31 23];
            app.EQLabel.Text = 'EQ';

            % Create VolumeKnobLabel
            app.VolumeKnobLabel = uilabel(app.UIFigure);
            app.VolumeKnobLabel.HorizontalAlignment = 'center';
            app.VolumeKnobLabel.Position = [352 271 45 22];
            app.VolumeKnobLabel.Text = 'Volume';

            % Create VolumeKnob
            app.VolumeKnob = uiknob(app.UIFigure, 'continuous');
            app.VolumeKnob.ValueChangedFcn = createCallbackFcn(app, @VolumeKnobValueChanged, true);
            app.VolumeKnob.Position = [355 315 39 39];
            app.VolumeKnob.Value = 50;

            % Create TempoKnobLabel
            app.TempoKnobLabel = uilabel(app.UIFigure);
            app.TempoKnobLabel.HorizontalAlignment = 'center';
            app.TempoKnobLabel.Position = [442 271 41 22];
            app.TempoKnobLabel.Text = 'Tempo';

            % Create TempoKnob
            app.TempoKnob = uiknob(app.UIFigure, 'continuous');
            app.TempoKnob.Limits = [-100 100];
            app.TempoKnob.ValueChangedFcn = createCallbackFcn(app, @TempoKnobValueChanged, true);
            app.TempoKnob.Position = [443 315 39 39];

            % Create PFactorKnobLabel
            app.PFactorKnobLabel = uilabel(app.UIFigure);
            app.PFactorKnobLabel.HorizontalAlignment = 'center';
            app.PFactorKnobLabel.Position = [351 174 51 22];
            app.PFactorKnobLabel.Text = 'P-Factor';

            % Create PFactorKnob
            app.PFactorKnob = uiknob(app.UIFigure, 'continuous');
            app.PFactorKnob.Limits = [-100 100];
            app.PFactorKnob.Position = [357 218 39 39];

            % Create DFactorKnobLabel
            app.DFactorKnobLabel = uilabel(app.UIFigure);
            app.DFactorKnobLabel.HorizontalAlignment = 'center';
            app.DFactorKnobLabel.Position = [437 174 51 22];
            app.DFactorKnobLabel.Text = 'D-Factor';

            % Create DFactorKnob
            app.DFactorKnob = uiknob(app.UIFigure, 'continuous');
            app.DFactorKnob.ValueChangedFcn = createCallbackFcn(app, @DFactorKnobValueChanged, true);
            app.DFactorKnob.Position = [443 218 39 39];

            % Create SynthButton
            app.SynthButton = uibutton(app.UIFigure, 'push');
            app.SynthButton.FontWeight = 'bold';
            app.SynthButton.Position = [565 363 202 23];
            app.SynthButton.Text = 'Synth';

            % Create SineButton
            app.SineButton = uibutton(app.UIFigure, 'push');
            app.SineButton.ButtonPushedFcn = createCallbackFcn(app, @SineButtonPushed, true);
            app.SineButton.FontWeight = 'bold';
            app.SineButton.Position = [551 288 73 52];
            app.SineButton.Text = 'Sine';

            % Create SawtoothButton
            app.SawtoothButton = uibutton(app.UIFigure, 'push');
            app.SawtoothButton.ButtonPushedFcn = createCallbackFcn(app, @SawtoothButtonPushed, true);
            app.SawtoothButton.FontWeight = 'bold';
            app.SawtoothButton.Position = [623 288 77 52];
            app.SawtoothButton.Text = 'Sawtooth';

            % Create SquareButton
            app.SquareButton = uibutton(app.UIFigure, 'push');
            app.SquareButton.ButtonPushedFcn = createCallbackFcn(app, @SquareButtonPushed, true);
            app.SquareButton.FontWeight = 'bold';
            app.SquareButton.Position = [699 288 74 52];
            app.SquareButton.Text = 'Square';

            % Create BeginsEditFieldLabel
            app.BeginsEditFieldLabel = uilabel(app.UIFigure);
            app.BeginsEditFieldLabel.HorizontalAlignment = 'right';
            app.BeginsEditFieldLabel.Position = [321 130 53 22];
            app.BeginsEditFieldLabel.Text = 'Begin (s)';

            % Create BeginsEditField
            app.BeginsEditField = uieditfield(app.UIFigure, 'numeric');
            app.BeginsEditField.Position = [389 130 100 22];

            % Create EndsEditFieldLabel
            app.EndsEditFieldLabel = uilabel(app.UIFigure);
            app.EndsEditFieldLabel.HorizontalAlignment = 'right';
            app.EndsEditFieldLabel.Position = [331 108 43 22];
            app.EndsEditFieldLabel.Text = 'End (s)';

            % Create EndsEditField
            app.EndsEditField = uieditfield(app.UIFigure, 'numeric');
            app.EndsEditField.Position = [389 108 100 22];

            % Create CropAudioButton
            app.CropAudioButton = uibutton(app.UIFigure, 'push');
            app.CropAudioButton.ButtonPushedFcn = createCallbackFcn(app, @CropAudioButtonPushed, true);
            app.CropAudioButton.FontWeight = 'bold';
            app.CropAudioButton.Position = [300 68 202 23];
            app.CropAudioButton.Text = 'Crop Audio';

            % Create SampleRateadjkHzEditFieldLabel
            app.SampleRateadjkHzEditFieldLabel = uilabel(app.UIFigure);
            app.SampleRateadjkHzEditFieldLabel.HorizontalAlignment = 'right';
            app.SampleRateadjkHzEditFieldLabel.Position = [527 235 126 22];
            app.SampleRateadjkHzEditFieldLabel.Text = 'Sample Rate adj (kHz)';

            % Create SampleRateadjkHzEditField
            app.SampleRateadjkHzEditField = uieditfield(app.UIFigure, 'numeric');
            app.SampleRateadjkHzEditField.Position = [668 235 100 22];

            % Create AdjustSampleRateButton
            app.AdjustSampleRateButton = uibutton(app.UIFigure, 'push');
            app.AdjustSampleRateButton.ButtonPushedFcn = createCallbackFcn(app, @AdjustSampleRateButtonPushed, true);
            app.AdjustSampleRateButton.FontWeight = 'bold';
            app.AdjustSampleRateButton.Position = [565 196 202 23];
            app.AdjustSampleRateButton.Text = 'Adjust Sample Rate';

            % Create ENG6AudioSamplerLabel
            app.ENG6AudioSamplerLabel = uilabel(app.UIFigure);
            app.ENG6AudioSamplerLabel.Position = [528 108 123 22];
            app.ENG6AudioSamplerLabel.Text = 'ENG 6 Audio Sampler';

            % Create ByZhuoxuanShiJustinCanasNghiaNguyenLabel
            app.ByZhuoxuanShiJustinCanasNghiaNguyenLabel = uilabel(app.UIFigure);
            app.ByZhuoxuanShiJustinCanasNghiaNguyenLabel.Position = [528 87 268 22];
            app.ByZhuoxuanShiJustinCanasNghiaNguyenLabel.Text = 'By: Zhuoxuan Shi / Justin Canas / Nghia Nguyen';

            % Create PlayButton
            app.PlayButton = uibutton(app.UIFigure, 'push');
            app.PlayButton.ButtonPushedFcn = createCallbackFcn(app, @PlayButtonPushed, true);
            app.PlayButton.FontWeight = 'bold';
            app.PlayButton.Position = [376 394 68 23];
            app.PlayButton.Text = 'Play';

            % Create ReverseButton
            app.ReverseButton = uibutton(app.UIFigure, 'push');
            app.ReverseButton.ButtonPushedFcn = createCallbackFcn(app, @ReverseButtonPushed, true);
            app.ReverseButton.FontWeight = 'bold';
            app.ReverseButton.Position = [443 394 68 23];
            app.ReverseButton.Text = 'Reverse';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = audio_samp_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end