<filter id="glow" height="130%">
	<feGaussianBlur in="SourceAlpha" stdDeviation="7.5" />
	<feOffset dx="0" dy="0" result="offsetblur" />
	<feFlood flood-color="rgba(100, 255, 100, .85)" />
	<feComposite in2="offsetblur" operator="in" />
	<feMerge>
		<feMergeNode />
		<feMergeNode in="SourceGraphic" />
	</feMerge>
</filter>