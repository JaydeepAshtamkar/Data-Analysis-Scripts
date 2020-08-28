import cv2
import sys

image = cv2.imread(r"C:\Users\Ideapad-330S\Desktop\VK.jpg")
grayimage = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
grayimageinv = 236 - grayimage
grayimageinv = cv2.GaussianBlur(grayimageinv, (21, 21), 50)

output = cv2.divide(grayimage, 255 - grayimageinv, scale = 240.0)
cv2.namedWindow("image", cv2.WINDOW_AUTOSIZE)
#cv2.namedWindow("pencilsketch", cv2.WINDOW_AUTOSIZE)
cv2.imshow("image", image)
cv2.imshow("penchilsketch", output)
cv2.waitKey(0)
cv2.destryAllWindows()
