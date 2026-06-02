// src/main/java/com/economiangola/dto/request/ReacaoRequest.java
package com.economiangola.dto.request;

import com.economiangola.domain.enums.TipoReacao;
import jakarta.validation.constraints.NotNull;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReacaoRequest {

    @NotNull(message = "O tipo de reação é obrigatório")
    private TipoReacao tipoReacao;
}
