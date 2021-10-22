<!DOCTYPE HTML>
<html>
	<head>
		<title>Search and Map</title>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1" />
		<link rel="stylesheet" href="assets/css/main.css" />
	</head>
	<body>
		<!-- Header -->
		<?php include "./header.html" ?>
		<a href="#menu" class="navPanelToggle"><span class="fa fa-bars"></span></a>
		</form>
		<!-- Main -->
		<section id="main" class="wrapper">
			<div class="container">
				<header class="major special">
					<h2>Map</h2>
				</header>
				<?php
					require_once("conn.php");
					// require_once("debug.php");
					if (isset($_POST['formSubmit'])) {
						$choice = $_POST['dropdown'];						
						$errorMessage = "";
						$sql = "SELECT thor_data_viet_id, tgtlatdd_ddd_wgs84, tgtlonddd_ddd_wgs84 FROM base_bombing_info WHERE mil_service = :choice 
							AND tgtlatdd_ddd_wgs84 IS NOT NULL AND tgtlonddd_ddd_wgs84 IS NOT NULL LIMIT 50";
						try {
							$prepared_stmt = $dbo->prepare($sql);
							$prepared_stmt->bindValue(':choice', $choice, PDO::PARAM_STR);
							$prepared_stmt->execute();
							$result = $prepared_stmt->fetchAll(); 
						} catch (PDOException $ex) { // Error in database processing.
							echo $sql . "<br>" . $error->getMessage(); // HTTP 500 - Internal Server Error
						}
					} 
				?>
				<h1> Search by </h1>

				</select>
				<form action="<?php echo htmlentities($_SERVER['PHP_SELF']); ?>" method="post">
					<select name="dropdown">
						<option value="USAF">US Airforce</option>
						<option value="USMC">US Marine Corps</option>
						<option value="USN">US Navy</option>
						<option value="VNAF">Vietnam Airforce</option>
						<option value="RLAF">Royal Lao Airforce</option>
						<option value="KAF">Korean Airforce</option>
						<option value="RAAF">Royal Australian Airforce</option>
					</select><br>
					<input type="submit" name="formSubmit" value="Submit">
				</form>
				<p><br />Map of Vietnam<br /></p>
				<div id="floating-panel">
					<button id="drop" onclick="writeToArray()">Drop Markers</button>
				</div>
				<div id="map" style="width:100%;height:800px;"></div>
				<script>
					var markers = [], latLongs = [], markerThorIDs = [];
					var map;

					function initMap() {
						map = new google.maps.Map(document.getElementById('map'), {
						zoom: 5,
						center: {lat: 14.0583, lng: 108.2772}
						});
					}

					function writeToArray() {
						var jsonArray = eval('<?php echo json_encode($result); ?>');
						console.log(jsonArray);
						for (var json of jsonArray) {
							// markerThorIDs.push(parseInt(json.thor_data_viet_id));
							markerThorIDs.push(json.thor_data_viet_id);
							latLongs.push({lat: parseFloat(json.tgtlatdd_ddd_wgs84), lng: parseFloat(json.tgtlonddd_ddd_wgs84)});
						}
						console.log(latLongs);
						drop();
					}

					function drop() {
						clearMarkers();
						for (var i = 0; i < latLongs.length; i++) {
							addMarkerWithTimeout(latLongs[i], markerThorIDs[i], i * 100);
						}
					}
					
					function addMarkerWithTimeout(position, id, timeout) {
						window.setTimeout(function() {
							var marker = new google.maps.Marker({
								position: position,
								map: map,
								animation: google.maps.Animation.DROP
							});
							attachOperationLink(marker, id);
							markers.push(marker);
						}, timeout);

					}

					function attachOperationLink(marker, id) {
						const permalink = `https://vietnambombingoperations.com/view.php?id=${id}`;
						// var infowindow = new google.maps.InfoWindow({
						// 	content: permalink
						// });
						marker.addListener('click', function() {
							window.open(
								permalink,
								'_blank' // new tab
							);
							// self.location.href = permalink;
							// infowindow.open(marker.get('map'), marker);
						});
					}

					function clearMarkers() {
						for (var i = 0; i < markers.length; i++) {
							markers[i].setMap(null);
						}
						markers = [];
					}
				</script>
				<script async defer 
					src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBvasMfd_jxlIea9xyE4TPC3UpRFnOgYpw&callback=initMap">
				</script>
				<!-- Image -->
				<section>
					<h3>Images of Vietnam War</h3>
					<div class="box alt">
						<div class="row 50% uniform">
							<div class="12u$"><span class="image fit"><img src="images/pic01.jpg" alt="" /></span></div>
							<div class="4u"><span class="image fit"><img src="images/pic02.jpg" alt="" /></span></div>
							<div class="4u"><span class="image fit"><img src="images/pic03.jpg" alt="" /></span></div>
							<div class="4u$"><span class="image fit"><img src="images/pic04.jpg" alt="" /></span></div>
							<div class="4u"><span class="image fit"><img src="images/pic05.jpg" alt="" /></span></div>
							<div class="4u"><span class="image fit"><img src="images/pic06.jpg" alt="" /></span></div>
							<div class="4u$"><span class="image fit"><img src="images/pic07.jpg" alt="" /></span></div>
						</div>
					</div>
					<p><span class="image right"><img src="images/pic04.jpg" alt="" /></span>This image depicts a US soldier giving a Mars bar to a young Vietnamese girl during a war where civilian casulaties were very high.</p>
					<p><span class="image left"><img src="images/pic05.jpg" alt="" /></span>This is an image of American soldiers around a dying Viet Cong soldier. The US soldiers respected his bravery and dedication after he fought for 3 days with his intestines in a soup bowl.<br /><br /><br /><br /><br /><br /><br /><br /></p>
				</section>

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
