%% 背景
% 斜坡参数
slope_length = 5; %10 斜坡长度
slope_angle = 30; % 斜坡角度（度）
slope_height = slope_length * sind(slope_angle); % 斜坡高度
slope_long= slope_length * cosd(slope_angle); % 斜坡底边
% 平地参数
ground_length = 15; % 平地长度
% 初始化位置和速度
ball_position = [0, slope_height];
ball_velocity = 0;
block_position = slope_long+0.8; % 方块开始的位置
%% 量化
% 小球和方块参数
ball_mass = 2; % 小球质量
block_mass = 5; % 方块质量
friction_coefficient = 0.2; % 摩擦系数
% 重力加速度
g = 9.81;
%% 公式
% 计算小球在斜坡上的加速度
a_slope = g * sind(slope_angle);
Ek = ball_mass*g*slope_height;% 计算方块的总能量
v0 = sqrt(2*Ek/block_mass);
v = v0; % 当前速度
% 计算加速度
a = -friction_coefficient * g;
% 计算停止时间
t_stop = -v0 / a;
% 计算移动距离
s = v0^2 / (2 * a);
%% 动态变量
% 时间参数
dt = 0.005; % 时间步长
t_final = sqrt(2 * slope_length / a_slope) + t_stop; % 总时间
time = 0:dt:t_final; % 时间数组
%% 展示
% 创建图形窗口
figure;
hold on;
axis equal;
xlim([0, slope_long + ground_length]);
ylim([0, slope_height + 1]);
xlabel('Distance');
ylabel('Height');
% 绘制斜坡和平地
plot([0, slope_length * cosd(slope_angle)], [slope_height, 0], 'k', 'LineWidth', 2);
plot([slope_long, slope_long + ground_length], [0, 0], 'k', 'LineWidth', 2);
% 初始化动画对象
ball = plot(ball_position(1), ball_position(2), 'ro', 'MarkerSize', 20, 'MarkerFaceColor', 'r');
block = plot(block_position, 0, 'bs', 'MarkerSize', 10, 'MarkerFaceColor', 'b');
% 创建视频文件
video = VideoWriter('ball_and_block_mass2.mp4', 'MPEG-4');
open(video);
% 动画循环
for t = time
    if ball_position(2) > 0
        % 小球在斜坡上
        ball_velocity = ball_velocity + a_slope * dt;
        ball_position = ball_position + [cosd(slope_angle), -sind(slope_angle)] * ball_velocity * dt;
    else
        % 小球在平地上
        if block_position < slope_length + ground_length
            % 推动方块
            force = ball_mass * g * friction_coefficient;
            acceleration = force / block_mass;
            % 模拟运动直到速度减至零
            if v > 0
                % 计算当前时间步的位移
                delta_s = v * dt + 0.5 * a * dt^2;
                if v < 0
                    v = 0;
                end
            end
            deltaBP = delta_s;
            block_position = block_position + deltaBP;
        end
    end
    
    % 更新动画对象位置
    set(ball, 'XData', ball_position(1), 'YData', max(ball_position(2), 0));
    set(block, 'XData', block_position);
    
    drawnow;
    frame = getframe(gcf);
    writeVideo(video, frame);
end
% 关闭视频文件
close(video);