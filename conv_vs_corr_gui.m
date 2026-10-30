function conv_vs_corr_gui
    % Create main UI figure window
    fig = uifigure('Name', 'Convolution vs Correlation Comparator', ...
                   'Position', [100, 100, 950, 700], ...
                   'Color', [0.95, 0.95, 0.97]);

    % Grid Layout: Left Panel for Controls, Right Panel for Visualizations
    gridMain = uigridlayout(fig, [1, 2]);
    gridMain.ColumnWidth = {280, '1x'};
    gridMain.Padding = [15, 15, 15, 15];
    gridMain.ColumnSpacing = 15;

    % ================= CONTROL PANEL =================
    controlPanel = uipanel(gridMain, 'Title', 'Configuration & Inputs', ...
                           'FontSize', 14, 'FontWeight', 'bold', ...
                           'BackgroundColor', [1 1 1]);
    gridControls = uigridlayout(controlPanel, [10, 1]);
    gridControls.RowHeight = {25, 35, 25, 35, 25, 35, 40, 25, 70, '1x'};

    % Signal x[n] Input
    uilabel(gridControls, 'Text', 'Signal x[n] (comma/space separated):', 'FontWeight', 'bold');
    editX = uieditfield(gridControls, 'text', 'Value', '1, 2, 3, 1');

    % Signal h[n] Input
    uilabel(gridControls, 'Text', 'Filter / Signal h[n]:', 'FontWeight', 'bold');
    editH = uieditfield(gridControls, 'text', 'Value', '1, 1, 0.5');

    % Presets Dropdown
    uilabel(gridControls, 'Text', 'Or Select a Preset:', 'FontWeight', 'bold');
    presetDropdown = uidropdown(gridControls, ...
        'Items', {'Custom', 'Asymmetric Pulses', 'Step & Ramp', 'Identical Square Pulses'}, ...
        'Value', 'Custom', ...
        'ValueChangedFcn', @(src, event) onPresetChange());

    % Compare Button
    btnCompare = uibutton(gridControls, 'push', ...
        'Text', 'Compute & Compare', ...
        'FontSize', 13, 'FontWeight', 'bold', ...
        'BackgroundColor', [0.18, 0.53, 0.82], 'FontColor', [1 1 1], ...
        'ButtonPushedFcn', @(src, event) updatePlots());

    % Mode Display
    uilabel(gridControls, 'Text', 'Mathematical Summary:', 'FontWeight', 'bold');
    lblMath = uilabel(gridControls, 'WordWrap', 'on', 'FontSize', 11, ...
        'Text', sprintf(['• Conv: h[n] is flipped and shifted: \\Sigma x[k]h[n-k]\n', ...
                         '• Corr: h[n] is shifted directly: \\Sigma x[k]h[k-n]']));

    % ================= PLOTS PANEL =================
    plotPanel = uipanel(gridMain, 'Title', 'Comparison Visualizations', ...
                        'FontSize', 14, 'FontWeight', 'bold', ...
                        'BackgroundColor', [1 1 1]);
    gridPlots = uigridlayout(plotPanel, [4, 1]);
    gridPlots.RowHeight = {'1x', '1x', '1x', '1x'};

    % Create Axes
    axX = uiaxes(gridPlots);
    axH = uiaxes(gridPlots);
    axConv = uiaxes(gridPlots);
    axCorr = uiaxes(gridPlots);

    % Run initial plot
    updatePlots();

    % ================= CALLBACK FUNCTIONS =================
    function onPresetChange()
        switch presetDropdown.Value
            case 'Asymmetric Pulses'
                editX.Value = '1, 2, 3, 4, 2';
                editH.Value = '1, 0.5, 0.2';
            case 'Step & Ramp'
                editX.Value = '1, 1, 1, 1, 1';
                editH.Value = '1, 2, 3';
            case 'Identical Square Pulses'
                editX.Value = '1, 1, 1, 1';
                editH.Value = '1, 1, 1, 1';
        end
        updatePlots();
    end

    function updatePlots()
        % Parse Inputs
        try
            x = str2num(editX.Value); %#ok<ST2NM>
            h = str2num(editH.Value); %#ok<ST2NM>
            if isempty(x) || isempty(h)
                uialert(fig, 'Invalid array input. Please enter numbers separated by spaces or commas.', 'Input Error');
                return;
            end
        catch
            uialert(fig, 'Error parsing arrays.', 'Parsing Error');
            return;
        end

        % Ensure row vectors
        x = x(:)';
        h = h(:)';

        Nx = length(x);
        Nh = length(h);

        % Compute Convolution and Cross-Correlation
        y_conv = conv(x, h);
        y_corr = conv(x, fliplr(h));

        % Axis indices (causal reference starting at index 0)
        nx = 0:(Nx - 1);
        nh = 0:(Nh - 1);
        n_conv = 0:(length(y_conv) - 1);
        
        % For correlation, lags span from -(Nh - 1) to (Nx - 1)
        lags_corr = -(Nh - 1):(Nx - 1);

        % Plot Signal x[n]
        stem(axX, nx, x, 'filled', 'LineWidth', 1.5, 'Color', [0.1 0.4 0.8]);
        title(axX, 'Input Signal x[n]');
        xlabel(axX, 'n'); ylabel(axX, 'Amplitude');
        grid(axX, 'on');

        % Plot Signal h[n] and Flipped h[-n]
        stem(axH, nh, h, 'filled', 'LineWidth', 1.5, 'Color', [0.85 0.33 0.1]);
        hold(axH, 'on');
        stem(axH, -nh, fliplr(h), '--o', 'LineWidth', 1.2, 'Color', [0.49 0.18 0.56]);
        hold(axH, 'off');
        title(axH, 'Filter/Signal h[n] (solid orange) vs. Time-Reversed h[-n] (dashed purple)');
        xlabel(axH, 'n'); ylabel(axH, 'Amplitude');
        grid(axH, 'on');

        % Plot Convolution: y[n] = x[n] * h[n]
        stem(axConv, n_conv, y_conv, 'filled', 'LineWidth', 1.5, 'Color', [0.18 0.64 0.29]);
        title(axConv, sprintf('Convolution: x[n] * h[n] (Length = %d)', length(y_conv)));
        xlabel(axConv, 'n'); ylabel(axConv, 'Amplitude');
        grid(axConv, 'on');

        % Plot Correlation: R_xh[k]
        stem(axCorr, lags_corr, y_corr, 'filled', 'LineWidth', 1.5, 'Color', [0.75 0.15 0.2]);
        title(axCorr, sprintf('Cross-Correlation: x[n] \\star h[n] (Length = %d)', length(y_corr)));
        xlabel(axCorr, 'Lag (k)'); ylabel(axCorr, 'Amplitude');
        grid(axCorr, 'on');
    end
end