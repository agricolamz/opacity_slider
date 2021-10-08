library(shiny)
library(lingtypology)
library(leaflet)

villages <- readr::read_tsv("https://raw.githubusercontent.com/sverhees/master_villages/master/data/villages_corr.csv")

villages <- villages[-c(which(is.na(villages$lat))),]
villages$lang <- ifelse(villages$lang == "Dargwa", "North Dargwa", villages$lang)
villages$lang <- ifelse(villages$lang == "Azerbaijani", "Northern Azerbaijani", villages$lang)
villages$lang <- ifelse(villages$lang == "Tsova-Tush", "Bats", villages$lang)
villages$lang <- ifelse(villages$lang == "Armenian", "Eastern Armenian", villages$lang)
villages$lang <- ifelse(villages$lang == "Tat", "Muslim Tat", villages$lang)
villages$lang <- ifelse(villages$lang == "Khwarshi", "Khwarshi-Inkhoqwari", villages$lang)
villages$aff_col <- ifelse(villages$aff == "Andic", "#9900ff", villages$aff_col)

villages_dot <- villages[sample(1:nrow(villages), 30),]


# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Test opacity slider"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("opacity",
                        "Opacity",
                        min = 0,
                        max = 1,
                        value = 0.7)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            leafletOutput("MYMAP", height = 600, width = 800))

    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$MYMAP <- renderLeaflet({
        map.feature(language = villages$lang, 
                    features = villages$aff, 
                    latitude = villages$lat,
                    longitude = villages$lon,
                    label = villages$village,
                    color = villages$aff_col,
                    opacity = input$opacity) %>% 
        map.feature(language = villages_dot$lang, 
                    features = villages_dot$aff, 
                    latitude = villages_dot$lat,
                    longitude = villages_dot$lon,
                    label = villages_dot$village,
                    color = villages_dot$aff_col,
                    #legend = FALSE,
                    pipe.data = .,
                    legend = FALSE)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
