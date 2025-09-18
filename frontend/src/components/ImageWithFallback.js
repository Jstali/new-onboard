import React, { useState } from "react";

const ImageWithFallback = ({
  src,
  alt,
  className = "",
  fallbackSrc = "/fallback.png",
  onError: customOnError,
  ...props
}) => {
  const [hasError, setHasError] = useState(false);
  const [currentSrc, setCurrentSrc] = useState(src);

  const handleError = (e) => {
    const target = e.target;
    const failingSrc = target.src;

    // Log the error with useful information
    console.error("❌ Image load error:", failingSrc);

    // Call custom error handler if provided
    if (customOnError) {
      customOnError(e);
    }

    // Only set fallback if we haven't already tried the fallback
    if (!hasError && failingSrc !== fallbackSrc) {
      setHasError(true);
      setCurrentSrc(fallbackSrc);
    } else if (failingSrc === fallbackSrc) {
      // If fallback also fails, prevent infinite loop
      console.error("❌ Fallback image also failed to load:", fallbackSrc);
      setCurrentSrc(
        "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTAwIiBoZWlnaHQ9IjEwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iMTAwIiBoZWlnaHQ9IjEwMCIgZmlsbD0iI2Y1ZjVmNSIvPjx0ZXh0IHg9IjUwIiB5PSI1MCIgZm9udC1mYW1pbHk9IkFyaWFsLCBzYW5zLXNlcmlmIiBmb250LXNpemU9IjEyIiBmaWxsPSIjOTk5IiB0ZXh0LWFuY2hvcj0ibWlkZGxlIiBkeT0iLjNlbSI+SW1hZ2UgRXJyb3I8L3RleHQ+PC9zdmc+"
      );
    }
  };

  return (
    <img
      src={currentSrc}
      alt={alt}
      className={className}
      onError={handleError}
      {...props}
    />
  );
};

export default ImageWithFallback;
