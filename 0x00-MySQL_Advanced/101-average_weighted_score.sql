-- Stored procedure ComputeAverageWeightedScoreForUsers
DROP PROCEDURE IF EXISTS ComputeAverageWeightedScoreForUsers;
DELIMITER //
CREATE PROCEDURE ComputeAverageWeightedScoreForUsers()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE user_id INT;
    DECLARE total_score FLOAT DEFAULT 0;
    DECLARE total_weight INT DEFAULT 0;
    DECLARE avg_score FLOAT DEFAULT 0;

    -- Cursor to iterate over user IDs
    DECLARE cur CURSOR FOR SELECT id FROM users;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO user_id;
        IF done THEN
            LEAVE read_loop;
        END IF;

        SET total_score = 0;
        SET total_weight = 0;

        -- Calculate total score and total weight for the user
        SELECT SUM(score * weight), SUM(weight)
        INTO total_score, total_weight
        FROM corrections
        INNER JOIN projects ON corrections.project_id = projects.id
        WHERE corrections.user_id = user_id;

        IF total_weight > 0 THEN
            SET avg_score = total_score / total_weight;
        END IF;

        -- Update average score for the user
        UPDATE users
        SET average_score = avg_score
        WHERE id = user_id;
    END LOOP;

    CLOSE cur;
END //
DELIMITER ;

