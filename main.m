 %% initial variables

SCREEN_NUMBER = 0;

BG_COLOR = [0, 0, 0];
WINDOW_RECT = [0,0, 1500, 1000];
R = 50;
FRACTAL_NUMBERS = 48; 
NUMBER_OF_AVALABLE_FRACTAL_SHOWS = [3, 5, 7, 9];


TRIALS = 144;

%% subject variables
SUBJECT_NAME = 'ERIK';
SUBJECT_ID = 401102778;
%% inital show variables

state = 0;
next_satae = 1;
% fixation 
FIXATION_CIRCLE_RADIUS = 10;
FIXATION_TIME = 0.5; 
FIXATION_DISAPPEAR_TIME = 0.0 ; 

%% initial uploads of data
[H_image, W_image, fractals] = upload_fractals('data', FRACTAL_NUMBERS);
value_of_fractal = give_initial_0_1_for_subject(SUBJECT_ID, FRACTAL_NUMBERS);
%% initial calculations
[p_n3, p_n5, p_n7, p_n9] = initialize_position_for_all_n(WINDOW_RECT, R, W_image, H_image);

    

%% window start
[w_ptr, WINDOW_RECT] = Screen('OpenWindow', SCREEN_NUMBER, BG_COLOR, WINDOW_RECT);

WINDOW_CENTER = [WINDOW_RECT(3) - WINDOW_RECT(1), WINDOW_RECT(4) - WINDOW_RECT(2)]/2;

%% showing fractals
% number_of_fractals_shown = NUMBER_OF_AVALABLE_FRACTAL_SHOWS(randi(4)) 
% for i = 1:number_of_fractals_shown
% 
%     img = fractals(i,:,:,:);
%     img = reshape(img, [W_image, H_image, 3]);
%     my_texture = Screen('MakeTexture', w_ptr, img);
% 
%     if number_of_fractals_shown == 3 
%         Screen('DrawTexture', w_ptr, my_texture, [], p_n3(:,i));
%     elseif number_of_fractals_shown == 5
%         Screen('DrawTexture', w_ptr, my_texture, [], p_n5(:,i));
%     elseif number_of_fractals_shown == 7 
%         Screen('DrawTexture', w_ptr, my_texture, [], p_n7(:,i));
%     elseif number_of_fractals_shown == 9 
%         Screen('DrawTexture', w_ptr, my_texture, [], p_n9(:,i));
%     end
% 
% end
% Screen('Flip', w_ptr);
% 
% 
% KbWait();
% sca();


%% enterinng the main loop

rng('shuffle');


while state ~= 10
    disp(state)
    
    if state == 0
        trial = 0;
        next_state = 1;
    elseif state == 1
        trial = trial + 1; 

        % fixation
        Screen('DrawDots', w_ptr,WINDOW_CENTER, FIXATION_CIRCLE_RADIUS, [0, 0, 255], [], 2 );
        Screen('Flip', w_ptr);
        WaitSecs(FIXATION_TIME);
        next_state = 2;
    elseif state == 2
        % fixation dissappear 
        Screen('Flip', w_ptr);
        WaitSecs(FIXATION_DISAPPEAR_TIME);
        

        % object selection
        number_of_fractals_in_this_set = randsample(NUMBER_OF_AVALABLE_FRACTAL_SHOWS,1);

        use_value_group = randsample([0, 1], 1);
        if use_value_group
            fractals_to_select = 1 : (FRACTAL_NUMBERS/2 );
        else
            fractals_to_select = (FRACTAL_NUMBERS/2+1):(FRACTAL_NUMBERS);
        end


        to_have_high_value = randsample([0, 1], 1);
        [fractal_indexees, index_of_high_fractal] = select_fractals_for_one_set( ...
                                                    fractals_to_select, ...
                                                    value_of_fractal(fractals_to_select), ...
                                                    to_have_high_value, ...
                                                    number_of_fractals_in_this_set);

        
        
       

        next_state = 10;

    elseif state == 3 
        %object selection
        

    elseif state == 4
        % display off

    elseif state == 5
        % NO PRESS 


    elseif state == 6
        % REJECT PRESS TA


    elseif state == 7
        % REJECT PRESS TP


    elseif state == 8
        % REWARD DELIVARY 


    elseif state == 9
        % ending
        break
    end
        



state = next_state;
end


KbWait();
sca();

