package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
	"time"

	"math/rand"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/template/html/v2"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

type Article struct {
	ID        uint      `json:"id" gorm:"primarykey;<-:create"`
	Title     string    `json:"title"`
	Detail    string    `json:"detail"`
	Image     string    `json:"image"`
	CreatedAt time.Time `json:"created_at" gorm:"default:now()"`
}

func ConnectDB() *gorm.DB {
	localhost := os.Getenv("DB_HOST")
	password := os.Getenv("DB_PASSWORD")
	username := os.Getenv("DB_USERNAME")
	database := os.Getenv("DB_NAME")
	port, err := strconv.Atoi(os.Getenv("DB_PORT"))
	if err != nil {
		panic(err)
	}

	url := fmt.Sprintf("%s:%s@(%s:%d)/%s?charset=utf8mb4&parseTime=True&loc=Local", username, password, localhost, port, database)

	con, err := gorm.Open(mysql.Open(url), &gorm.Config{})

	if err != nil {
		panic("failed to connect database")

	}

	return con
}

func main() {
	engine := html.New("./views", ".html")

	app := fiber.New(fiber.Config{
		Views: engine,
	})

	app.Static("/public", "./public")

	app.Get("/", func(c *fiber.Ctx) error {
		var articles []Article
		ConnectDB().Order("id desc").Find(&articles)

		return c.Render("home", fiber.Map{
			"title":    "Inesdi Blog",
			"articles": articles,
		})
	})

	app.Get("/article/:image", func(c *fiber.Ctx) error {
		filename := c.Params("image")
		filePath := "./storage/articles/" + filename
		return c.SendFile(filePath)
	})

	app.Post("/save", func(c *fiber.Ctx) error {
		file, err := c.FormFile("imageArticle")
		if err != nil {
			return err
		}

		nameOriginImage := strings.Split(file.Filename, ".")
		typeImage := nameOriginImage[len(nameOriginImage)-1]
		hashImage := fmt.Sprintf("%s.%s", hashImageString(10), typeImage)

		article := Article{
			Title:  c.FormValue("title"),
			Detail: c.FormValue("description"),
			Image:  hashImage,
		}

		if err := ConnectDB().Model(Article{}).Create(&article).Error; err != nil {
			panic(err)
		}

		c.SaveFile(file, fmt.Sprintf("./storage/articles/%s", hashImage))

		return c.Redirect("/")
	})

	app.Listen(":3000")
}

func hashImageString(length int) string {
	const charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	seed := rand.NewSource(time.Now().UnixNano())
	random := rand.New(seed)

	result := make([]byte, length)
	for i := range result {
		result[i] = charset[random.Intn(len(charset))]
	}
	return string(result)
}
