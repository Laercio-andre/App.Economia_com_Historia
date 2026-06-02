// src/main/java/com/economiangola/domain/entity/Conquista.java
package com.economiangola.domain.entity;

import com.economiangola.domain.enums.CriterioTipo;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "conquistas")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Conquista extends BaseEntity {

    @Column(name = "nome", nullable = false, unique = true, length = 100)
    private String nome;

    @Column(name = "descricao", length = 500)
    private String descricao;

    @Column(name = "icone_url", length = 500)
    private String iconeUrl;

    @Enumerated(EnumType.STRING)
    @Column(name = "criterio_tipo", nullable = false, length = 30)
    private CriterioTipo criterioTipo;

    @Column(name = "criterio_valor", nullable = false)
    private Integer criterioValor;

    @Column(name = "pontos_bonificacao", nullable = false)
    @Builder.Default
    private Integer pontosBonificacao = 0;
}
