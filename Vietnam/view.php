<!DOCTYPE HTML>
<html>
	<head>
		<title>View Specific Operation</title>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1" />
		<link rel="stylesheet" href="assets/css/main.css" />
	</head>
	<body>
		<!-- Header -->
		<?php include "./header.html" ?>
		<a href="#menu" class="navPanelToggle"><span class="fa fa-bars"></span></a>
		<!-- Main -->
			<section id="main" class="wrapper">
				<div class="container">
					<header class="major special">
						<h2>View Operation</h2>
						<p>About</p>
					</header>
                    <?php
                        require_once 'conn.php';
                        $id = null;
                        if ( !empty($_GET['id'])) {
                            $id = $_REQUEST['id'];
                        }
                        
                        if ( null==$id ) {
                            header("Location: index.php");
                        } else {
                            $sql = "SELECT * FROM search_view where thor_data_viet_id = :id";
                            try {
                                $prepared_stmt = $dbo->prepare($sql);
                                $prepared_stmt->bindValue(':id', $id, PDO::PARAM_INT);
                                $prepared_stmt->execute();
                                $result = $prepared_stmt->fetchAll(); 
                            } catch (PDOException $ex) { // Error in database processing.
                                echo $sql . "<br>" . $error->getMessage(); // HTTP 500 - Internal Server Error
                            }                            
                        }
                        if ($result && $prepared_stmt->rowCount() > 0) { ?>
                            <h2>Results</h2>
                            <table>
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Airplane Type</th>
                                        <th>Weapon Type</th>
                                        <th>Date</th>
                                        <th>Military Branch</th>
                                        <th>Takeoff Location</th>
                                    </tr>
                                </thead>
                                <tbody>
    
                                    <?php foreach ($result as $row) { ?>
    
                                        <tr>
                                            <td><?php echo $row["thor_data_viet_id"]; ?></td>
                                            <td><?php echo $row["valid_aircraft_root"]; ?></td>
                                            <td><?php echo $row["weapon_type"]; ?></td>
                                            <td><?php echo $row["msn_date"]; ?></td>
                                            <td><?php echo $row["mil_service"]; ?></td>
                                            <td><?php echo $row["takeoff_location"]; ?></td>
                                        </tr>
                                    <?php } ?>
                                </tbody>
                            </table>
    
                        <?php } else { ?>
                            > No results found for <?php echo $id; ?>.
                    <?php } ?>
 
				</div>
			</section>
					<!-- Footer -->
					<footer id="footer">
						<div class="container">
						</div>
					</footer>

		<!-- Scripts -->
			<script src="assets/js/jquery.min.js"></script>
			<script src="assets/js/skel.min.js"></script>
			<script src="assets/js/util.js"></script>
			<script src="assets/js/main.js"></script>

	</body>
</html>
