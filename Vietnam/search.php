<!DOCTYPE HTML>
<html>
	<head>
		<title>Search</title>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1" />
		<link rel="stylesheet" href="assets/css/main.css" />
	</head>
	<body class="landing">
		<!-- Header -->
		<?php include "./header.html" ?>
		<p>
		<a href="#menu" class="navPanelToggle"><span class="fa fa-bars"></span></a>
		<section id="main" class="wrapper">
			<div class="container">
				<header class="major special">
					<p><br /><h2>Search</h2></p>
					<p>Search the Database For Information</p>
				</header>
				<a href="#" class="image fit"><img src="images/pic01.jpg" alt="" /></a>
				<p>Search Based of Category of Interest use empty for no restrictions and date should be in the form of year-month-day</p>
				<?php

				require_once("conn.php");
				
				if (isset($_POST['formSubmit'])) {
					$value = $_POST['value'];
					$choice = $_POST['dropdown'];
					$errorMessage = "";
					$sql = "SELECT thor_data_viet_id, valid_aircraft_root, weapon_type, msn_date, 
						mil_service, takeoff_location FROM search_view ";
					$sql .= (empty($value)) ? "LIMIT 50" : "WHERE $choice = :value LIMIT 50";
					try {
						$prepared_stmt = $dbo->prepare($sql);
						if (!empty($value)) {
							$prepared_stmt->bindValue(':value', $value, PDO::PARAM_STR);
						}
						$prepared_stmt->execute();
						$result = $prepared_stmt->fetchAll();
					} catch (PDOException $ex) { // Error in database processing.
						echo $sql . "<br>" . $error->getMessage(); // HTTP 500 - Internal Server Error
					}
					
				}
				if (isset($_POST['formSubmit'])) {
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
						> No results found for <?php echo $_POST['dropdown']; ?>.
				<?php }
				} ?>
				<form action="<?php echo htmlentities($_SERVER['PHP_SELF']); ?>" method="post">
					<select name="dropdown">
						<option value="valid_aircraft_root">Airplane</option>
						<option value="weapon_type">Weapon Type</option>
						<option value="msn_date">Date</option>
						<option value="mil_service">Military Branch</option>
						<option value="takeoff_location">Takeoff Location</option>
					</select><br>
					<p><br />Specify The Column Value</p>
					<input type="text" name="value">
					<input type="submit" name="formSubmit" value="Submit">
				</form>
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
